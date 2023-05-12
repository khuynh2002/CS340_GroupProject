const express = require('express');
const app = express();

app.get('/', (req, res) => {
    res.send('CS 340 Group Project');
});

app.listen(3000, () => {
    console.log('Server listening on port 3000');
});