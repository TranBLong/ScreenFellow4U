const { mssql } = require('../config/db');

// GET all tours with pagination
exports.getAllTours = async (req, res) => {
    try {
        const { page = 1, limit = 10, search = '' } = req.query;
        const offset = (page - 1) * limit;

        const pool = await mssql.connect();
        const request = pool.request();

        // Get total count
        const countResult = await request
            .input('search', mssql.NVarChar(255), `%${search}%`)
            .query(`
                SELECT COUNT(*) as total 
                FROM Tours 
                WHERE IsActive = 1 
                AND (Title LIKE @search OR Description LIKE @search)
            `);

        const total = countResult.recordset[0].total;

        // Get tours with pagination
        const result = await request
            .input('offset', mssql.Int, offset)
            .input('limit', mssql.Int, limit)
            .query(`
                SELECT 
                    TourID, Title, Description, Price, OriginalPrice, Duration, 
                    DepartureDate, DeparturePlace, Itinerary, ProviderName, 
                    Rating, TotalLikes, TotalReviews, CoverImageUrl, CreatedAt
                FROM Tours 
                WHERE IsActive = 1 
                AND (Title LIKE @search OR Description LIKE @search)
                ORDER BY CreatedAt DESC
                OFFSET @offset ROWS
                FETCH NEXT @limit ROWS ONLY
            `);

        res.json({
            success: true,
            data: result.recordset,
            pagination: {
                page: parseInt(page),
                limit: parseInt(limit),
                total: total,
                totalPages: Math.ceil(total / limit)
            }
        });
    } catch (error) {
        console.error('Error fetching tours:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// GET tour by ID with all details
exports.getTourById = async (req, res) => {
    try {
        const { id } = req.params;
        const pool = await mssql.connect();
        const request = pool.request();

        // Get tour details
        const tourResult = await request
            .input('tourId', mssql.Int, id)
            .query(`
                SELECT * FROM Tours WHERE TourID = @tourId AND IsActive = 1
            `);

        if (tourResult.recordset.length === 0) {
            return res.status(404).json({ success: false, error: 'Tour not found' });
        }

        const tour = tourResult.recordset[0];

        // Get tour images
        const imagesResult = await request
            .input('tourId', mssql.Int, id)
            .query(`
                SELECT ImageID, ImageUrl 
                FROM TourImages 
                WHERE TourID = @tourId
                ORDER BY SortOrder
            `);

        // Get tour schedules
        const schedulesResult = await request
            .input('tourId', mssql.Int, id)
            .query(`
                SELECT ScheduleID, DayNumber, RouteLabel 
                FROM TourSchedules 
                WHERE TourID = @tourId
                ORDER BY DayNumber
            `);

        // Get schedule items for each schedule
        const schedulesWithItems = await Promise.all(
            schedulesResult.recordset.map(async (schedule) => {
                const itemsResult = await request
                    .input('scheduleId', mssql.Int, schedule.ScheduleID)
                    .query(`
                        SELECT ItemID, TimeSlot, Description 
                        FROM TourScheduleItems 
                        WHERE ScheduleID = @scheduleId
                        ORDER BY SortOrder
                    `);
                return {
                    ...schedule,
                    items: itemsResult.recordset
                };
            })
        );

        // Get pricing
        const pricingResult = await request
            .input('tourId', mssql.Int, id)
            .query(`
                SELECT PricingID, Label, Price, IsFree 
                FROM TourPricing 
                WHERE TourID = @tourId
                ORDER BY SortOrder
            `);

        // Get reviews
        const reviewsResult = await request
            .input('tourId', mssql.Int, id)
            .query(`
                SELECT r.ReviewID, r.Rating, r.Comment, r.CreatedAt, 
                       u.UserID, u.FullName, u.Avatar
                FROM TourReviews r
                LEFT JOIN Users u ON r.UserID = u.UserID
                WHERE r.TourID = @tourId
                ORDER BY r.CreatedAt DESC
            `);

        res.json({
            success: true,
            data: {
                tour,
                images: imagesResult.recordset,
                schedules: schedulesWithItems,
                pricing: pricingResult.recordset,
                reviews: reviewsResult.recordset
            }
        });
    } catch (error) {
        console.error('Error fetching tour details:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// GET featured tours
exports.getFeaturedTours = async (req, res) => {
    try {
        const { limit = 10 } = req.query;
        const pool = await mssql.connect();
        const request = pool.request();

        const result = await request
            .input('limit', mssql.Int, limit)
            .query(`
                SELECT TOP (@limit)
                    TourID, Title, Price, OriginalPrice, Rating, TotalLikes, 
                    TotalReviews, CoverImageUrl, ProviderName, Itinerary
                FROM Tours 
                WHERE IsActive = 1
                ORDER BY TotalLikes DESC, Rating DESC
            `);

        res.json({
            success: true,
            data: result.recordset
        });
    } catch (error) {
        console.error('Error fetching featured tours:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// GET top rated tours
exports.getTopRatedTours = async (req, res) => {
    try {
        const { limit = 10 } = req.query;
        const pool = await mssql.connect();
        const request = pool.request();

        const result = await request
            .input('limit', mssql.Int, limit)
            .query(`
                SELECT TOP (@limit)
                    TourID, Title, Price, Rating, TotalReviews, 
                    CoverImageUrl, ProviderName, Itinerary
                FROM Tours 
                WHERE IsActive = 1 AND TotalReviews > 0
                ORDER BY Rating DESC, TotalReviews DESC
            `);

        res.json({
            success: true,
            data: result.recordset
        });
    } catch (error) {
        console.error('Error fetching top rated tours:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// BOOKMARK: Add tour to bookmarks
exports.bookmarkTour = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.body.userId; // Should come from auth middleware

        if (!userId) {
            return res.status(401).json({ success: false, error: 'User not authenticated' });
        }

        const pool = await mssql.connect();
        const request = pool.request();

        // Check if already bookmarked
        const checkResult = await request
            .input('userId', mssql.Int, userId)
            .input('tourId', mssql.Int, id)
            .query(`
                SELECT * FROM TourBookmarks 
                WHERE UserID = @userId AND TourID = @tourId
            `);

        if (checkResult.recordset.length > 0) {
            return res.status(400).json({ success: false, error: 'Already bookmarked' });
        }

        // Add bookmark
        await request
            .input('userId', mssql.Int, userId)
            .input('tourId', mssql.Int, id)
            .query(`
                INSERT INTO TourBookmarks (UserID, TourID, CreatedAt)
                VALUES (@userId, @tourId, GETDATE())
            `);

        res.json({ success: true, message: 'Tour bookmarked successfully' });
    } catch (error) {
        console.error('Error bookmarking tour:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// REMOVE BOOKMARK
exports.removeBookmark = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.body.userId;

        if (!userId) {
            return res.status(401).json({ success: false, error: 'User not authenticated' });
        }

        const pool = await mssql.connect();
        const request = pool.request();

        const result = await request
            .input('userId', mssql.Int, userId)
            .input('tourId', mssql.Int, id)
            .query(`
                DELETE FROM TourBookmarks 
                WHERE UserID = @userId AND TourID = @tourId
            `);

        if (result.rowsAffected[0] === 0) {
            return res.status(404).json({ success: false, error: 'Bookmark not found' });
        }

        res.json({ success: true, message: 'Bookmark removed successfully' });
    } catch (error) {
        console.error('Error removing bookmark:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// GET user bookmarks
exports.getUserBookmarks = async (req, res) => {
    try {
        const userId = req.body.userId;

        if (!userId) {
            return res.status(401).json({ success: false, error: 'User not authenticated' });
        }

        const pool = await mssql.connect();
        const request = pool.request();

        const result = await request
            .input('userId', mssql.Int, userId)
            .query(`
                SELECT t.TourID, t.Title, t.Price, t.OriginalPrice, t.Rating, 
                       t.CoverImageUrl, t.ProviderName, b.CreatedAt
                FROM TourBookmarks b
                JOIN Tours t ON b.TourID = t.TourID
                WHERE b.UserID = @userId
                ORDER BY b.CreatedAt DESC
            `);

        res.json({
            success: true,
            data: result.recordset
        });
    } catch (error) {
        console.error('Error fetching user bookmarks:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// LIKE: Add like to tour
exports.likeTour = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.body.userId;

        if (!userId) {
            return res.status(401).json({ success: false, error: 'User not authenticated' });
        }

        const pool = await mssql.connect();
        const request = pool.request();

        // Check if already liked
        const checkResult = await request
            .input('userId', mssql.Int, userId)
            .input('tourId', mssql.Int, id)
            .query(`
                SELECT * FROM TourLikes 
                WHERE UserID = @userId AND TourID = @tourId
            `);

        if (checkResult.recordset.length > 0) {
            return res.status(400).json({ success: false, error: 'Already liked' });
        }

        // Add like
        await request
            .input('userId', mssql.Int, userId)
            .input('tourId', mssql.Int, id)
            .query(`
                INSERT INTO TourLikes (UserID, TourID, CreatedAt)
                VALUES (@userId, @tourId, GETDATE());
                
                UPDATE Tours 
                SET TotalLikes = TotalLikes + 1 
                WHERE TourID = @tourId
            `);

        res.json({ success: true, message: 'Tour liked successfully' });
    } catch (error) {
        console.error('Error liking tour:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// UNLIKE: Remove like from tour
exports.unlikeTour = async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.body.userId;

        if (!userId) {
            return res.status(401).json({ success: false, error: 'User not authenticated' });
        }

        const pool = await mssql.connect();
        const request = pool.request();

        const result = await request
            .input('userId', mssql.Int, userId)
            .input('tourId', mssql.Int, id)
            .query(`
                DELETE FROM TourLikes 
                WHERE UserID = @userId AND TourID = @tourId;
                
                UPDATE Tours 
                SET TotalLikes = CASE WHEN TotalLikes > 0 THEN TotalLikes - 1 ELSE 0 END
                WHERE TourID = @tourId
            `);

        if (result.rowsAffected[0] === 0) {
            return res.status(404).json({ success: false, error: 'Like not found' });
        }

        res.json({ success: true, message: 'Like removed successfully' });
    } catch (error) {
        console.error('Error unliking tour:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// POST REVIEW
exports.postReview = async (req, res) => {
    try {
        const { id } = req.params;
        const { userId, rating, comment } = req.body;

        if (!userId) {
            return res.status(401).json({ success: false, error: 'User not authenticated' });
        }

        if (!rating || rating < 1 || rating > 5) {
            return res.status(400).json({ success: false, error: 'Rating must be between 1 and 5' });
        }

        const pool = await mssql.connect();
        const request = pool.request();

        // Check if user already reviewed this tour
        const checkResult = await request
            .input('userId', mssql.Int, userId)
            .input('tourId', mssql.Int, id)
            .query(`
                SELECT * FROM TourReviews 
                WHERE UserID = @userId AND TourID = @tourId
            `);

        if (checkResult.recordset.length > 0) {
            return res.status(400).json({ success: false, error: 'You already reviewed this tour' });
        }

        // Insert review
        const insertResult = await request
            .input('tourId', mssql.Int, id)
            .input('userId', mssql.Int, userId)
            .input('rating', mssql.Decimal(3, 1), rating)
            .input('comment', mssql.NVarChar(mssql.MAX), comment || null)
            .query(`
                INSERT INTO TourReviews (TourID, UserID, Rating, Comment, CreatedAt)
                OUTPUT INSERTED.ReviewID
                VALUES (@tourId, @userId, @rating, @comment, GETDATE());
                
                UPDATE Tours 
                SET TotalReviews = TotalReviews + 1,
                    Rating = (
                        SELECT AVG(Rating) FROM TourReviews WHERE TourID = @tourId
                    )
                WHERE TourID = @tourId
            `);

        res.json({
            success: true,
            message: 'Review posted successfully',
            data: { ReviewID: insertResult.recordset[0]?.ReviewID }
        });
    } catch (error) {
        console.error('Error posting review:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// GET REVIEWS for a tour
exports.getTourReviews = async (req, res) => {
    try {
        const { id } = req.params;
        const { page = 1, limit = 10 } = req.query;
        const offset = (page - 1) * limit;

        const pool = await mssql.connect();
        const request = pool.request();

        // Get total count
        const countResult = await request
            .input('tourId', mssql.Int, id)
            .query(`
                SELECT COUNT(*) as total FROM TourReviews WHERE TourID = @tourId
            `);

        const total = countResult.recordset[0].total;

        // Get reviews with pagination
        const result = await request
            .input('tourId', mssql.Int, id)
            .input('offset', mssql.Int, offset)
            .input('limit', mssql.Int, limit)
            .query(`
                SELECT 
                    r.ReviewID, r.Rating, r.Comment, r.CreatedAt, 
                    u.UserID, u.FullName, u.Avatar
                FROM TourReviews r
                LEFT JOIN Users u ON r.UserID = u.UserID
                WHERE r.TourID = @tourId
                ORDER BY r.CreatedAt DESC
                OFFSET @offset ROWS
                FETCH NEXT @limit ROWS ONLY
            `);

        res.json({
            success: true,
            data: result.recordset,
            pagination: {
                page: parseInt(page),
                limit: parseInt(limit),
                total: total,
                totalPages: Math.ceil(total / limit)
            }
        });
    } catch (error) {
        console.error('Error fetching reviews:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};

// SEARCH TOURS by filters
exports.searchTours = async (req, res) => {
    try {
        const { 
            keyword = '', 
            minPrice, 
            maxPrice, 
            minRating, 
            departure,
            page = 1,
            limit = 10
        } = req.query;

        const offset = (page - 1) * limit;
        const pool = await mssql.connect();
        const request = pool.request();

        let query = `
            SELECT TourID, Title, Price, OriginalPrice, Rating, TotalReviews,
                   CoverImageUrl, ProviderName, Itinerary, DepartureDate, Duration
            FROM Tours 
            WHERE IsActive = 1
        `;

        // Add search filters
        if (keyword) {
            request.input('keyword', mssql.NVarChar(255), `%${keyword}%`);
            query += ` AND (Title LIKE @keyword OR Description LIKE @keyword OR Itinerary LIKE @keyword)`;
        }

        if (minPrice) {
            request.input('minPrice', mssql.Decimal(10, 2), minPrice);
            query += ` AND Price >= @minPrice`;
        }

        if (maxPrice) {
            request.input('maxPrice', mssql.Decimal(10, 2), maxPrice);
            query += ` AND Price <= @maxPrice`;
        }

        if (minRating) {
            request.input('minRating', mssql.Decimal(3, 1), minRating);
            query += ` AND Rating >= @minRating`;
        }

        if (departure) {
            request.input('departure', mssql.NVarChar(255), `%${departure}%`);
            query += ` AND DeparturePlace LIKE @departure`;
        }

        // Get total count
        const countResult = await request.query(`
            SELECT COUNT(*) as total FROM Tours WHERE IsActive = 1 ${query.split('WHERE IsActive = 1')[1]}
        `);

        const total = countResult.recordset[0].total;

        // Get paginated results
        request.input('offset', mssql.Int, offset);
        request.input('limit', mssql.Int, limit);

        const result = await request.query(`
            ${query}
            ORDER BY CreatedAt DESC
            OFFSET @offset ROWS
            FETCH NEXT @limit ROWS ONLY
        `);

        res.json({
            success: true,
            data: result.recordset,
            pagination: {
                page: parseInt(page),
                limit: parseInt(limit),
                total: total,
                totalPages: Math.ceil(total / limit)
            }
        });
    } catch (error) {
        console.error('Error searching tours:', error.message);
        res.status(500).json({ success: false, error: error.message });
    }
};
