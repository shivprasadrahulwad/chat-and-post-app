const Confession = require('../models/confession');
const mongoose = require('mongoose');
const { ObjectId } = mongoose.Types;

const sendConfession = async (req, res) => {
    try {
      const {
        content,
        category,
        userId,
        isAnonymous,
        mentions = [],
        createdAt,
        reportReason  // Added reportReason
      } = req.body;
  
      if (!content || !category || !userId) {
        return res.status(400).json({ error: 'Required fields are missing' });
      }
  
      // Validate ObjectId
      if (!mongoose.Types.ObjectId.isValid(userId)) {
        return res.status(400).json({ error: 'Invalid userId format' });
      }
  
      console.log('Confession started');
  
      const confessionData = {
        content,
        category,
        userId: new mongoose.Types.ObjectId(userId),  // Convert to ObjectId
        createdAt: createdAt ? new Date(createdAt) : new Date(),
        isAnonymous: isAnonymous ?? true,
        mentions: Array.isArray(mentions) ? mentions : [],
        likesCount: 0,
        commentsCount: 0,
        isDeleted: false,
        isReported: false,
        reportReason: reportReason || null,  // Handle reportReason
      };
  
      const newConfession = await Confession.create(confessionData);
  
      if (!newConfession) {
        return res.status(500).json({ error: 'Failed to save confession' });
      }
  
      // Check user's daily quota
      const today = new Date();
      const startOfDay = new Date(today.setHours(0, 0, 0, 0));
      const endOfDay = new Date(today.setHours(23, 59, 59, 999));
  
      const userConfessionsToday = await Confession.countDocuments({
        userId: new mongoose.Types.ObjectId(userId),
        createdAt: {
          $gte: startOfDay,
          $lte: endOfDay
        }
      });
  
    //   if (userConfessionsToday > 3) {
    //     return res.status(400).json({ error: 'Daily confession quota exceeded' });
    //   }
  
      res.status(201).json(newConfession);
    } catch (error) {
      console.error('Error in sendConfession:', error);
      res.status(500).json({ error: error.message || 'Internal server error' });
    }
  };


  const fetchConfessionsAfterDate = async (req, res) => {
    try {
      const { timestamp } = req.query;
      const limit = parseInt(req.query.limit) || 50;
      
      // Validate timestamp
      const queryTimestamp = new Date(timestamp);
      if (isNaN(queryTimestamp.getTime())) {
        return res.status(400).json({ error: 'Invalid timestamp format' });
      }
  
      // Build query for confessions after the timestamp
      const query = {
        createdAt: {
          $gt: queryTimestamp
        },
        isDeleted: false
      };
  
      // Fetch confessions
      const confessions = await Confession.find(query)
        .sort({ createdAt: 1 }) // Sort by creation date ascending
        .limit(limit)
        .populate('userId', 'username'); // Populate user data if needed
  
      res.status(200).json(confessions);
      
    } catch (error) {
      console.error('Error in fetchConfessionsAfterDate:', error);
      res.status(500).json({ error: error.message || 'Internal server error' });
    }
  };


  const reportConfession = async (req, res) => {
    try {
      console.log('Received report request:', req.body);
  
      const { confessionId, userId, reportReason, isReported } = req.body;
  
      // Validate required fields
      if (!confessionId) {
        console.log('Missing confessionId');
        return res.status(400).json({ error: 'Confession ID is required' });
      }
  
      if (!reportReason) {
        console.log('Missing report reason');
        return res.status(400).json({ error: 'Report reason is required' });
      }
  
      // Update the confession's reported status
      const updatedConfession = await Confession.findByIdAndUpdate(
        confessionId,
        {
          isReported: isReported ?? true,
          reportReason,
          $set: {
            'reportDetails': {
              reportedBy: userId,
              reportedAt: new Date(),
              reason: reportReason
            }
          }
        },
        { new: true }
      );
  
      if (!updatedConfession) {
        console.log('Confession not found');
        return res.status(404).json({ error: 'Confession not found' });
      }
  
      console.log('Confession reported successfully:', updatedConfession);
      return res.status(200).json(updatedConfession);
    } catch (error) {
      console.error('Error in reportConfession:', error);
      return res.status(500).json({ 
        error: error.message || 'Internal server error'
      });
    }
  };
  

  module.exports = { sendConfession ,fetchConfessionsAfterDate, reportConfession};