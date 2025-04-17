const express = require('express');
const router = express.Router();
const Note = require('../models/Note');

// Lấy tất cả note của một tài khoản
router.get('/:idAccount', async (req, res) => {
  try {
    const notes = await Note.find({ idAccount: req.params.idAccount });
    res.json(notes);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

// Tạo một note mới
router.post('/', async (req, res) => {
  const note = new Note({
    title: req.body.title,
    content: req.body.content,
    priority: req.body.priority,
    createAt: new Date(req.body.createAt),
    modifiedAt: new Date(req.body.modifiedAt),
    tags: req.body.tags,
    color: req.body.color,
    idAccount: req.body.idAccount
  });

  try {
    const newNote = await note.save();
    res.status(201).json(newNote);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Cập nhật một note
router.put('/:id', async (req, res) => {
  try {
    const note = await Note.findById(req.params.id);
    if (!note) return res.status(404).json({ message: 'Không tìm thấy note' });

    Object.assign(note, req.body, { modifiedAt: new Date() });
    const updatedNote = await note.save();
    res.json(updatedNote);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Xóa một note
router.delete('/:id', async (req, res) => {
  try {
    const note = await Note.findById(req.params.id);
    if (!note) return res.status(404).json({ message: 'Không tìm thấy note' });

    await note.deleteOne();
    res.json({ message: 'Đã xóa note' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;