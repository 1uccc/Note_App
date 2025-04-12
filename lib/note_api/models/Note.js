const mongoose = require('mongoose');

const noteSchema = new mongoose.Schema({
    title: { type: String, required: true },
    content: { type: String, required: true },
    priority: { type: Number, required: true },
    createAt: { type: Date, default: Date.now },
    modifiedAt: { type: Date, default: Date.now },
    tags: { type: [String], default: [] },
    color: { type: String }
});

module.exports = mongoose.model('Note', noteSchema);
