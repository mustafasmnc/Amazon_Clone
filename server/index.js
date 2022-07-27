// imports packages
const express = require('express')
const mongoose = require('mongoose')
require('dotenv').config()


// import from other files
const authRouter = require('./routes/auth')

// init
const PORT = process.env.PORT || 3000
const app = express()

// middleware
app.use(authRouter)

// mongodb connections
const DB = process.env.MONGO_DB; //Mongodb link
mongoose.connect(DB).then(() => {
    console.log('Connected to MongoDB')
}).catch((err) => {
    console.log(`Error: ${err}`)
})

app.listen(PORT, () => {
    console.log(`Connected to ${PORT}`)
})