const express = require('express')
const productRouter = express.Router()
const auth = require('../middlewares/auth')
const Product = require('../models/product')

//get all products
productRouter.get('/api/products', auth, async (req, res) => {
    try {
        //get all products
        const products = await Product.find({ category: req.query.category })
        res.json(products)

    } catch (error) {
        res.status(500).json({ error: error.message })
    }
})

module.exports = productRouter