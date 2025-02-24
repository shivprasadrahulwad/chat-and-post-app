const express = require("express");
const mongoose = require("mongoose");
const ObjectId = mongoose.Types.ObjectId;
const auth = require("../middleware/auth");
const postRouter = express.Router();

const {
    sendPost,
    getPosts,
    reportPost
  } = require("../controllers/postController");
postRouter.post('/api/sendPost', auth, sendPost);

postRouter.get('/api/posts', auth, getPosts);

postRouter.post('/api/reportPost', auth, reportPost);

module.exports = postRouter;