const Post = require('../models/post');
const mongoose = require('mongoose');



const sendPost = async (req, res) => {
  try {
    // Debug logging
    console.log('Received request body:', req.body);

    const {
      content,
      userId,
      mediaUrl,
      user,
      mentions = [],
      createdAt,
    } = req.body;

    // Detailed validation logging
    console.log('Validating fields:');
    console.log('content:', content);
    console.log('userId:', userId);
    console.log('user:', user);

    // Check each required field individually
    if (!content) {
      console.log('Missing content');
      return res.status(400).json({ error: 'Content is required' });
    }

    if (!userId) {
      console.log('Missing userId');
      return res.status(400).json({ error: 'UserId is required' });
    }

    if (!user) {
      console.log('Missing user preview data');
      return res.status(400).json({ error: 'User preview data is required' });
    }

    if (!user.id || !user.username) {
      console.log('Invalid user preview data:', user);
      return res.status(400).json({ error: 'Invalid user preview data - id and username are required' });
    }

    // Validate ObjectId
    if (!mongoose.Types.ObjectId.isValid(userId)) {
      console.log('Invalid userId format:', userId);
      return res.status(400).json({ error: 'Invalid userId format' });
    }

    const postData = {
      content,
      userId: new mongoose.Types.ObjectId(userId),
      mediaUrl: mediaUrl || null,
      user: {
        id: user.id,
        username: user.username,
        name: user.name || null,
        profileImage: user.profileImage || null
      },
      mentions: Array.isArray(mentions) ? mentions : [],
      createdAt: createdAt ? new Date(createdAt) : new Date(),
      likes: [],
      comments: [],
      commentCount: 0,
      isDeleted: false,
    };

    console.log('Creating post with data:', postData);

    const newPost = await Post.create(postData);

    if (!newPost) {
      console.log('Failed to create post');
      return res.status(500).json({ error: 'Failed to save post' });
    }

    console.log('Post created successfully:', newPost);
    res.status(201).json(newPost);
  } catch (error) {
    console.error('Error in sendPost:', error);
    res.status(500).json({ error: error.message || 'Internal server error' });
  }
};



const getPosts = async (req, res) => {
  try {
    const { afterDate } = req.query;

    if (!afterDate) {
      return res.status(400).json({ error: 'afterDate parameter is required' });
    }

    const parsedDate = new Date(afterDate);
    if (isNaN(parsedDate.getTime())) {
      return res.status(400).json({ error: 'Invalid date format' });
    }

    const posts = await Post.find({
      createdAt: { $gt: parsedDate },
      isDeleted: false
    })
    .sort({ createdAt: -1 })
    .populate('userId', 'username avatar') // ✅ Correct field to populate
    .exec();

    if (!posts || posts.length === 0) {
      return res.status(404).json({ error: 'No posts found' });
    }

    res.status(200).json(posts);
  } catch (error) {
    console.error('Error in getPosts:', error);
    res.status(500).json({ error: error.message || 'Internal server error' });
  }
};

const reportPost = async (req, res) => {
  try {
    console.log('Received request body:', req.body);

    const { postId, userId, reportReason, isReported } = req.body;

    // Validate required fields
    if (!postId) {
      console.log('Missing postId');
      return res.status(400).json({ error: 'Post ID is required' });
    }

    if (!reportReason) {
      console.log('Missing report reason');
      return res.status(400).json({ error: 'Report reason is required' });
    }

    // Update the post's reported status
    const updatedPost = await Post.findByIdAndUpdate(
      postId,
      { 
        isReported: isReported ?? true,
        reportReason,
        reportedBy: userId,  // Optional: track who reported
        reportedAt: new Date() // Optional: track when reported
      },
      { new: true }
    );

    if (!updatedPost) {
      console.log('Failed to report post');
      return res.status(404).json({ error: 'Post not found' });
    }

    console.log('Post reported successfully:', updatedPost);
    return res.status(200).json(updatedPost);
  } catch (error) {
    console.error('Error in reportPost:', error);
    res.status(500).json({ error: error.message || 'Internal server error' });
  }
};

  module.exports = { sendPost, getPosts, reportPost };