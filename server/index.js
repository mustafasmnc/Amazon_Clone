// imports packages
const express = require('express')
const mongoose = require('mongoose')

// import from other files
const authRouter = require('./routes/auth')

// init
const PORT = 3000
const app = express()

// middleware
app.use(authRouter)

app.listen(PORT, () => {
    console.log(`Connected to ${PORT}`)
})