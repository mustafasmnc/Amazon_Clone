// imports packages
const express = require('express')
const mongoose = require('mongoose')
require('dotenv').config()


// import from other files
const authRouter = require('./routes/auth')
const adminRouter = require('./routes/admin')
const productRouter = require('./routes/product')
const userRouter = require('./routes/user')

// init
const PORT = process.env.PORT || 3000
const app = express()

// middleware
app.use(express.json())
app.use(authRouter)
app.use(adminRouter)
app.use(productRouter)
app.use(userRouter)

// mongodb connections
const DB = process.env.MONGO_DB; //Mongodb link
mongoose.connect(DB).then(() => {
    console.log('Connected to MongoDB')
}).catch((err) => {
    console.log(`Error: ${err}`)
})

app.listen(PORT, "0.0.0.0", () => {
    console.log(`Connected to ${PORT}`)
})