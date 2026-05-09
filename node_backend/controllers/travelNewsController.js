const { mssql } = require('../config/db');

// @desc    Get all travel news
// @route   GET /api/travel-news
// @access  Public
const getTravelNews = async (req, res) => {
    try {
        const pool = await mssql.connect();
        const result = await pool.request().query(`
            SELECT tn.id, tn.title, tn.publish_date, tn.image_url, tn.summary, 
                   tn.view_count, tn.is_featured, tn.created_at, 
                   tnd.content, tnd.author, tnd.tags
            FROM travel_news tn
            LEFT JOIN travel_news_detail tnd ON tn.id = tnd.news_id
            WHERE tn.is_deleted = 0
            ORDER BY tn.publish_date DESC
        `);

        // Format dates
        const news = result.recordset.map(item => ({
            ...item,
            publish_date: item.publish_date ? item.publish_date.toISOString().split('T')[0] : null,
            created_at: item.created_at ? item.created_at.toISOString() : null
        }));

        res.json({
            success: true,
            data: news
        });
    } catch (error) {
        console.error(error);
        res.status(500).json({
            success: false,
            message: 'Server Error'
        });
    }
};

module.exports = {
    getTravelNews
};