const mongoose = require('mongoose');

// Define the user preview schema as a nested schema
const userPreviewSchema = new mongoose.Schema({
  id: { // Changed from _id to id to match your UserPreview model
    type: String,
    required: true
  },
  username: {
    type: String,
    required: true
  },
  name: {
    type: String
  },
  profileImage: {
    type: String
  }
}, { _id: false });