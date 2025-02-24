const express = require("express");
const mongoose = require("mongoose");
const auth = require("../middleware/auth");
const commentRouter = express.Router();
const { sendComment, getComments } = require("../controllers/commentController");

// Updated routes to match Flutter service endpoints
commentRouter.post('/api/sendComment', auth, sendComment);
commentRouter.get('/api/comments/:postId', auth, getComments);

module.exports = commentRouter;
