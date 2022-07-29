const express = require('express')
const User = require('../models/user')
const bcryptjs = require('bcryptjs')
const jwt = require('jsonwebtoken')
const auth = require('../middlewares/auth')

const authRouter = express.Router()

// sign up route
authRouter.post('/api/signup', async (req, res) => {
    try {
        const { name, email, password } = req.body

        const existingUser = await User.findOne({ email })
        if (existingUser) {
            return res.status(400).json({ msg: 'User with same email already exists!' })
        }

        const hashedPassword = await bcryptjs.hash(password, 8)

        let user = new User({
            email,
            password: hashedPassword,
            name,
        })
        user = await user.save()
        res.json(user)
    } catch (error) {
        res.status(500).json({ error: error.message })
    }

})

// sign in route
authRouter.post('/api/signin', async (req, res) => {
    try {
        const { email, password } = req.body

        const existingUser = await User.findOne({ email })
        if (!existingUser) {
            return res.status(400).json({ msg: 'User with this email does not exists!' })
        }

        const isMatchPassword = await bcryptjs.compare(password, existingUser.password)
        if (!isMatchPassword) {
            return res.status(400).json({ msg: 'Incorrect password!' })
        }

        const token = jwt.sign({ id: existingUser._id }, "passwordKey")
        res.json({ token, ...existingUser._doc })

    } catch (error) {
        res.status(500).json({ error: error.message })
    }

})

// check token is valid
authRouter.post('/TokenIsValid', async (req, res) => {
    try {
        const token = req.header('x-auth-token')
        if (!token) return res.json(false)

        const verified = jwt.verify(token, "passwordKey")
        if (!verified) return res.json(false)

        const existingUser = await User.findById(verified.id)
        if (!existingUser) return res.json(false)

        res.json(true)

    } catch (error) {
        res.status(500).json({ error: error.message })
    }

})

//get user data
authRouter.get('/', auth, async (req, res) => {
    const existingUser = await User.findById(req.user)
    res.json({ ...existingUser._doc, token: req.token })
})

module.exports = authRouter