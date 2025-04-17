const mongoose = require('mongoose');

const accountSchema = new mongoose.Schema({
  userId: { type: Number, required: true },
  username: { type: String, required: true },
  password: { type: String, required: true },
  status: { type: String, required: true },
  lastLogin: { type: String, required: true },
  createdAt: { type: String, required: true }
}, { timestamps: false });

module.exports = mongoose.model('Account', accountSchema);