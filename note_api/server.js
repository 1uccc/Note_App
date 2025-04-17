const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();

const noteRoutes = require('./routes/noteRoutes');
const accountRoutes = require('./routes/accountRoutes');

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Kết nối với MongoDB
mongoose.connect(process.env.MONGODB_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
    .then(() => console.log('Đã kết nối với MongoDB'))
    .catch(err => console.error('Lỗi kết nối MongoDB:', err));

// Định nghĩa các tuyến đường
app.use('/api/notes', noteRoutes);
app.use('/api/accounts', accountRoutes);

// Khởi động server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server đang chạy trên cổng ${PORT}`);
});