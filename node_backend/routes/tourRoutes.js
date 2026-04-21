const express = require('express');
const router = express.Router();
const tourController = require('../controllers/tourController');

// GET endpoints
router.get('/', tourController.getAllTours);                          // GET /api/tours
router.get('/featured', tourController.getFeaturedTours);            // GET /api/tours/featured
router.get('/top-rated', tourController.getTopRatedTours);           // GET /api/tours/top-rated
router.get('/search', tourController.searchTours);                   // GET /api/tours/search?keyword=...
router.get('/:id', tourController.getTourById);                      // GET /api/tours/:id
router.get('/:id/reviews', tourController.getTourReviews);           // GET /api/tours/:id/reviews

// BOOKMARK endpoints
router.post('/:id/bookmark', tourController.bookmarkTour);           // POST /api/tours/:id/bookmark
router.delete('/:id/bookmark', tourController.removeBookmark);       // DELETE /api/tours/:id/bookmark
router.get('/user/bookmarks', tourController.getUserBookmarks);      // GET /api/tours/user/bookmarks

// LIKE/UNLIKE endpoints
router.post('/:id/like', tourController.likeTour);                   // POST /api/tours/:id/like
router.post('/:id/unlike', tourController.unlikeTour);               // POST /api/tours/:id/unlike

// REVIEW endpoints
router.post('/:id/review', tourController.postReview);               // POST /api/tours/:id/review

module.exports = router;
