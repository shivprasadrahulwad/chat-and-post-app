// const mongoose = require('mongoose');

// const commentSchema = new mongoose.Schema({
//     postId: {
//       type: mongoose.Schema.Types.ObjectId,
//       ref: 'Post',
//       required: true
//     },
//     userId: {
//       type: mongoose.Schema.Types.ObjectId,
//       ref: 'User',
//       required: true
//     },
//     content: {
//       type: String,
//       required: true
//     },
//     likes: [{
//       type: mongoose.Schema.Types.ObjectId,
//       ref: 'User'
//     }],
//     parentComment: {
//       type: mongoose.Schema.Types.ObjectId,
//       ref: 'Comment',
//       default: null
//     },
//     createdAt: {
//       type: Date,
//       default: Date.now
//     }
//   });

// module.exports = mongoose.model('Comment', commentSchema);




const mongoose = require('mongoose');

const commentSchema = new mongoose.Schema({
  postId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Post',
    required: true,
    index: true // Add index for faster queries
  },
  postType: {
    type: String,
    enum: ['post', 'confession'],
    required: true,
    index: true
  },
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  content: {
    type: String,
    required: true,
    trim: true
  },
  parentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Comment',
    default: null,
    index: true // Add index for faster queries of replies
  },
  likes: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  replyCount: {
    type: Number,
    default: 0
  },
  createdAt: {
    type: Date,
    default: Date.now,
    index: true // Add index for sorting
  }
});

commentSchema.index({ postId: 1, postType: 1 });
commentSchema.index({ parentId: 1 });

const Comment = mongoose.model('Comment', commentSchema);
module.exports = Comment;