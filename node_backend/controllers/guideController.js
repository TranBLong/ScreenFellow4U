const { mssql } = require('../config/db');

exports.getAllGuides = async (req, res) => {
    try {
        const {
            page = 1,
            limit = 10,
            search = '',
            location = '',
            language = '',
        } = req.query;

        const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
        const pool = await mssql.connect();

        const countRequest = pool.request();
        countRequest.input('search', mssql.NVarChar(255), `%${search}%`);
        countRequest.input('location', mssql.NVarChar(255), location ? `%${location}%` : '');
        countRequest.input('language', mssql.NVarChar(50), language || '');

        const countResult = await countRequest.query(`
            SELECT COUNT(DISTINCT g.GuideID) AS total
            FROM Guides g
            LEFT JOIN GuideLanguages gl ON g.GuideID = gl.GuideID
            WHERE g.IsActive = 1
            AND (
                g.Name LIKE @search
                OR g.Location LIKE @search
                OR g.Description LIKE @search
                OR gl.Language LIKE @search
            )
            AND (@location = '' OR g.Location LIKE @location)
            AND (@language = '' OR gl.Language = @language)
        `);

        const total = countResult.recordset[0]?.total || 0;

        const dataRequest = pool.request();
        dataRequest.input('search', mssql.NVarChar(255), `%${search}%`);
        dataRequest.input('location', mssql.NVarChar(255), location ? `%${location}%` : '');
        dataRequest.input('language', mssql.NVarChar(50), language || '');
        dataRequest.input('offset', mssql.Int, offset);
        dataRequest.input('limit', mssql.Int, parseInt(limit, 10));

        const result = await dataRequest.query(`
            SELECT DISTINCT
                g.GuideID,
                g.Name,
                g.Location,
                g.Avatar AS Image,
                g.Description,
                g.Rating,
                g.Reviews,
                g.TotalLikes,
                g.CreatedAt
            FROM Guides g
            LEFT JOIN GuideLanguages gl ON g.GuideID = gl.GuideID
            WHERE g.IsActive = 1
            AND (
                g.Name LIKE @search
                OR g.Location LIKE @search
                OR g.Description LIKE @search
                OR gl.Language LIKE @search
            )
            AND (@location = '' OR g.Location LIKE @location)
            AND (@language = '' OR gl.Language = @language)
            ORDER BY g.CreatedAt DESC
            OFFSET @offset ROWS
            FETCH NEXT @limit ROWS ONLY
        `);

        res.json({
            success: true,
            data: result.recordset,
            pagination: {
                page: parseInt(page, 10),
                limit: parseInt(limit, 10),
                total,
                totalPages: Math.ceil(total / parseInt(limit, 10)),
            },
        });
    } catch (error) {
        console.error('Error fetching guides:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.getGuideById = async (req, res) => {
    try {
        const { id } = req.params;
        const pool = await mssql.connect();

        const guideRequest = pool.request();
        guideRequest.input('guideId', mssql.Int, id);
        const guideResult = await guideRequest.query(`
            SELECT GuideID, Name, Location, Avatar AS Image, Background, Description, Reviews, Rating, TotalLikes, IsActive, CreatedAt, UpdatedAt
            FROM Guides
            WHERE GuideID = @guideId AND IsActive = 1
        `);

        if (guideResult.recordset.length === 0) {
            return res.status(404).json({ success: false, error: 'Guide not found' });
        }

        const languagesRequest = pool.request();
        languagesRequest.input('guideId', mssql.Int, id);
        const languagesResult = await languagesRequest.query(`
            SELECT LanguageID, Language
            FROM GuideLanguages
            WHERE GuideID = @guideId
            ORDER BY SortOrder
        `);

        const pricingRequest = pool.request();
        pricingRequest.input('guideId', mssql.Int, id);
        const pricingResult = await pricingRequest.query(`
            SELECT PricingID, GroupLabel, Price, Currency
            FROM GuidePricing
            WHERE GuideID = @guideId
            ORDER BY SortOrder
        `);

        const experiencesRequest = pool.request();
        experiencesRequest.input('guideId', mssql.Int, id);
        const experiencesResult = await experiencesRequest.query(`
            SELECT ExperienceID, Title, Location, Date, Likes, IsLiked, SortOrder
            FROM GuideExperiences
            WHERE GuideID = @guideId
            ORDER BY SortOrder
        `);

        const experienceIds = experiencesResult.recordset.map((exp) => exp.ExperienceID);
        let experienceImages = [];

        if (experienceIds.length > 0) {
            const imagesRequest = pool.request();
            experienceImages = await imagesRequest.query(`
                SELECT ImageID, ExperienceID, ImageUrl, ImagePosition, SortOrder
                FROM GuideExperienceImages
                WHERE ExperienceID IN (${experienceIds.join(',')})
                ORDER BY ExperienceID, SortOrder
            `);
        }

        const reviewsRequest = pool.request();
        reviewsRequest.input('guideId', mssql.Int, id);
        const reviewsResult = await reviewsRequest.query(`
            SELECT ReviewID, Name, Date, Rating, Comment, AvatarUrl
            FROM GuideReviews
            WHERE GuideID = @guideId
            ORDER BY CreatedAt DESC
        `);

        res.json({
            success: true,
            data: {
                guide: guideResult.recordset[0],
                languages: languagesResult.recordset,
                pricing: pricingResult.recordset,
                experiences: experiencesResult.recordset,
                experienceImages: experienceImages.recordset || [],
                reviews: reviewsResult.recordset,
            },
        });
    } catch (error) {
        console.error('Error fetching guide details:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.getGuideReviews = async (req, res) => {
    try {
        const { id } = req.params;
        const { page = 1, limit = 10 } = req.query;
        const offset = (parseInt(page, 10) - 1) * parseInt(limit, 10);
        const pool = await mssql.connect();

        const reviewCountRequest = pool.request();
        reviewCountRequest.input('guideId', mssql.Int, id);
        const countResult = await reviewCountRequest.query(`
            SELECT COUNT(*) AS total
            FROM GuideReviews
            WHERE GuideID = @guideId
        `);

        const total = countResult.recordset[0]?.total || 0;

        const reviewsRequest = pool.request();
        reviewsRequest.input('guideId', mssql.Int, id);
        reviewsRequest.input('offset', mssql.Int, offset);
        reviewsRequest.input('limit', mssql.Int, parseInt(limit, 10));
        const reviewsResult = await reviewsRequest.query(`
            SELECT ReviewID, Name, Date, Rating, Comment, AvatarUrl
            FROM GuideReviews
            WHERE GuideID = @guideId
            ORDER BY CreatedAt DESC
            OFFSET @offset ROWS
            FETCH NEXT @limit ROWS ONLY
        `);

        res.json({
            success: true,
            data: reviewsResult.recordset,
            pagination: {
                page: parseInt(page, 10),
                limit: parseInt(limit, 10),
                total,
                totalPages: Math.ceil(total / parseInt(limit, 10)),
            },
        });
    } catch (error) {
        console.error('Error fetching guide reviews:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.getFeaturedGuides = async (req, res) => {
    try {
        const { limit = 10 } = req.query;
        const pool = await mssql.connect();
        const request = pool.request();
        request.input('limit', mssql.Int, parseInt(limit, 10));

        const result = await request.query(`
            SELECT TOP (@limit)
                GuideID, Name, Location, Avatar AS Image, Description, Rating, Reviews, TotalLikes
            FROM Guides
            WHERE IsActive = 1
            ORDER BY TotalLikes DESC, Rating DESC
        `);

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error('Error fetching featured guides:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

exports.getTopRatedGuides = async (req, res) => {
    try {
        const { limit = 10 } = req.query;
        const pool = await mssql.connect();
        const request = pool.request();
        request.input('limit', mssql.Int, parseInt(limit, 10));

        const result = await request.query(`
            SELECT TOP (@limit)
                GuideID, Name, Location, Avatar AS Image, Description, Rating, Reviews, TotalLikes
            FROM Guides
            WHERE IsActive = 1 AND Rating IS NOT NULL
            ORDER BY Rating DESC, Reviews DESC
        `);

        res.json({ success: true, data: result.recordset });
    } catch (error) {
        console.error('Error fetching top rated guides:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};
