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

//get all products
productRouter.get('/api/products/search/:name', auth, async (req, res) => {
    try {
        //get all products by search query
        const products = await Product.find({
            "$or": [
                { name: { '$regex': req.params.name, '$options': 'i' } },
                { description: { '$regex': req.params.name, '$options': 'i' } },
                { category: { '$regex': req.params.name, '$options': 'i' } }
            ]
        })
        res.json(products)

    } catch (error) {
        res.status(500).json({ error: error.message })
    }
})

module.exports = productRouter