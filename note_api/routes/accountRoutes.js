const express = require('express');
const router = express.Router();
const Account = require('../models/Account');

// Lấy tất cả tài khoản
router.get('/', async (req, res) => {
  try {
    const accounts = await Account.find();
    res.json(accounts);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});
// Đăng nhập tài khoản
router.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    const account = await Account.findOne({ username, password });

    if (!account) {
      return res.status(401).json({ message: 'Tên đăng nhập hoặc mật khẩu không đúng' });
    }

    // Cập nhật thời gian đăng nhập
    account.lastLogin = new Date().toISOString();
    await account.save();

    res.json(account);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});



// Tạo một tài khoản mới
router.post('/', async (req, res) => {
  const account = new Account({
    userId: req.body.userId,
    username: req.body.username,
    password: req.body.password,
    status: req.body.status,
    lastLogin: req.body.lastLogin,
    createdAt: req.body.createdAt
  });

  try {
    const newAccount = await account.save();
    res.status(201).json(newAccount);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Cập nhật một tài khoản
router.put('/:id', async (req, res) => {
  try {
    const account = await Account.findById(req.params.id);
    if (!account) return res.status(404).json({ message: 'Không tìm thấy tài khoản' });

    Object.assign(account, req.body, { lastLogin: new Date().toISOString() });
    const updatedAccount = await account.save();
    res.json(updatedAccount);
  } catch (error) {
    res.status(400).json({ message: error.message });
  }
});

// Xóa một tài khoản
router.delete('/:id', async (req, res) => {
  try {
    const account = await Account.findById(req.params.id);
    if (!account) return res.status(404).json({ message: 'Không tìm thấy tài khoản' });

    await account.deleteOne();
    res.json({ message: 'Đã xóa tài khoản' });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;