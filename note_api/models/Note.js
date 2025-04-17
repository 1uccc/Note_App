const mongoose = require('mongoose');

const noteSchema = new mongoose.Schema({
    title: { type: String, required: true },
    content: { type: String, required: true },
    priority: { type: Number, required: true },
    createAt: { type: Date, required: true },
    modifiedAt: { type: Date, required: true },
    tags: { type: [String], default: [] },
    color: { type: String, required: true },
    idAccount: { type: Number, required: true }
}, { timestamps: false });

module.exports = mongoose.model('Note', noteSchema);