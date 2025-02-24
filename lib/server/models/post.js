const mongoose = require('mongoose');
const userPreviewSchema = require('./userPreview');


const postSchema = new mongoose.Schema({
  content: {
    type: String,
    required: true,
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },  
  user: {
    type: userPreviewSchema,
    ref: 'User',
  },
  mediaUrl: {
    type: String,
  },
  likes: [{
    type: String,
    default: [],
  }],
  comments: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Comment',
    default: [],
  }],
  commentCount: {
    type: Number,
    default: 0,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  isDeleted: {
    type: Boolean,
    default: false,
  },
  isReported: {
    type: Boolean,
    default: false,
  },
  reportReason: {
    type: String,
  },
  isLikedByCurrentUser: {
    type: Boolean,
    default: false,
  },
});

module.exports = mongoose.model('Post', postSchema);