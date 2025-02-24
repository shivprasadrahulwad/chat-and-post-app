const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const confessionSchema = new Schema({
  content: {
    type: String,
    required: true,
  },
  category: {
    type: String,
    required: true,
  },
  userId: {
    type: Schema.Types.ObjectId,
    ref: 'User',
    required: true,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  isAnonymous: {
    type: Boolean,
    default: false,
  },
  mentions: [{
    type: String,
  }],
  likesCount: {
    type: Number,
    default: 0,
  },
  commentsCount: {
    type: Number,
    default: 0,
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

module.exports = mongoose.model('Confession', confessionSchema);