const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const noteRoutes = require('./routes/noteRoutes');

const app = express();
const PORT = 3000;
const MONGODB_URI = 'mongodb://localhost:27017/notes_app'; // hoặc dùng Atlas

// Middleware
app.use(cors());
app.use(bodyParser.json());

// Routes
app.use('/api/notes', noteRoutes);

// Connect MongoDB & Start server
mongoose.connect(MONGODB_URI, { useNewUrlParser: true, useUnifiedTopology: true })
    .then(() => {
        app.listen(PORT, () => {
            console.log(`✅ Server running at http://localhost:${PORT}`);
        });
    })
    .catch(err => console.error('❌ MongoDB connection error:', err));
