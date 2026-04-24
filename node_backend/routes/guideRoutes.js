const express = require('express');
const router = express.Router();
const guideController = require('../controllers/guideController');

router.get('/', guideController.getAllGuides);            // GET /api/guides
router.get('/featured', guideController.getFeaturedGuides); // GET /api/guides/featured
router.get('/top-rated', guideController.getTopRatedGuides); // GET /api/guides/top-rated
router.get('/:id', guideController.getGuideById);          // GET /api/guides/:id
router.get('/:id/reviews', guideController.getGuideReviews); // GET /api/guides/:id/reviews

module.exports = router;
