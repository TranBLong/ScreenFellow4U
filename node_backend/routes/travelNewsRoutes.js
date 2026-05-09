const express = require('express');
const router = express.Router();
const { getTravelNews } = require('../controllers/travelNewsController');

router.get('/', getTravelNews);

module.exports = router;