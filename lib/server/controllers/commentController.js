// commentController.js
const mongoose = require('mongoose');
const Comment = require('../models/comment');
const Confession = require('../models/confession');
const Post = require('../models/post');

const sendComment = async (req, res) => {
  try {
    const {
      content,
      postId,
      postType,
      userId,
      parentId,
      createdAt,
    } = req.body;

    if (!content || !postId || !postType || !userId) {
      return res.status(400).json({ error: 'Required fields are missing' });
    }

    // Validate ObjectId
    if (!mongoose.Types.ObjectId.isValid(userId) || !mongoose.Types.ObjectId.isValid(postId)) {
      return res.status(400).json({ error: 'Invalid ID format' });
    }

    // Check if parent post exists based on postType
    const PostModel = postType === 'confession' ? Confession : Post;
    const post = await PostModel.findById(postId);
    if (!post) {
      return res.status(404).json({ error: 'Parent post not found' });
    }

    // If this is a reply, check if parent comment exists
    if (parentId) {
      if (!mongoose.Types.ObjectId.isValid(parentId)) {
        return res.status(400).json({ error: 'Invalid parent comment ID' });
      }
      const parentComment = await Comment.findById(parentId);
      if (!parentComment) {
        return res.status(404).json({ error: 'Parent comment not found' });
      }
    }

    const commentData = {
      content,
      postId: new mongoose.Types.ObjectId(postId),
      postType,
      userId: new mongoose.Types.ObjectId(userId),
      parentId: parentId ? new mongoose.Types.ObjectId(parentId) : null,
      createdAt: createdAt ? new Date(createdAt) : new Date(),
      likes: [],
      replyCount: 0,
    };

    console.log('Comment Model:', Comment);


    const newComment = await Comment.create(commentData);

    // Update comment count on parent post
    await PostModel.findByIdAndUpdate(postId, { $inc: { commentsCount: 1 } });

    // If this is a reply, update parent comment's reply count
    if (parentId) {
      await Comment.findByIdAndUpdate(parentId, { $inc: { replyCount: 1 } });
    }

    // Populate user data
    const populatedComment = await Comment.findById(newComment._id).populate('userId', 'username profileImage');

    res.status(201).json(populatedComment);
  } catch (error) {
    console.error('Error in sendComment:', error);
    res.status(500).json({ error: error.message || 'Internal server error' });
  }
};

const getComments = async (req, res) => {
  try {
    const { postId } = req.params;
    const { postType } = req.query;

    if (!postId || !postType) {
      return res.status(400).json({ error: 'Post ID and type are required' });
    }

    if (!mongoose.Types.ObjectId.isValid(postId)) {
      return res.status(400).json({ error: 'Invalid post ID format' });
    }

    const comments = await Comment.find({
      postId: new mongoose.Types.ObjectId(postId),
      postType,
      parentId: null // Get only top-level comments
    })
    .populate('userId', 'username profileImage')
    .sort({ createdAt: -1 });

    // Get replies for each comment
    const commentsWithReplies = await Promise.all(comments.map(async (comment) => {
      const replies = await Comment.find({
        parentId: comment._id
      })
      .populate('userId', 'username profileImage')
      .sort({ createdAt: 1 });

      return {
        ...comment.toObject(),
        replies
      };
    }));

    res.status(200).json(commentsWithReplies);
  } catch (error) {
    console.error('Error in getComments:', error);
    res.status(500).json({ error: error.message || 'Internal server error' });
  }
};

module.exports = { sendComment, getComments };