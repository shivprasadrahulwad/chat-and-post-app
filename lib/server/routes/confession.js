const express = require("express");
const mongoose = require("mongoose");
const auth = require("../middleware/auth");
const confessionRouter = express.Router();

const {
    sendConfession,
    fetchConfessionsAfterDate,
    reportConfession,
  } = require("../controllers/confessionController");

confessionRouter.post('/api/sendConfession', auth, sendConfession);
confessionRouter.get('/api/confessions/after', auth, fetchConfessionsAfterDate);
confessionRouter.post('/api/confessions/report', auth, reportConfession);

module.exports = confessionRouter;