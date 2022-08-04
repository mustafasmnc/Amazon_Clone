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

//create a get request to search products and get them
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

//rate the product
productRouter.post('/api/rate-product', auth, async (req, res) => {
    try {
        const { id, rating } = req.body
        let product = await Product.findById(id)

        // if user rate the product before, delete old rate (splice fonk for deleting)
        for (let i = 0; i < product.ratings.length; i++) {
            if (product.ratings[i].userId == req.user) {
                product.ratings.splice(i, 1)
                break
            }
        }

        const ratingSchema = {
            userId: req.user,
            rating,
        }

        product.ratings.push(ratingSchema)
        product = await product.save()
        res.json(product)
    } catch (error) {
        res.status(500).json({ error: error.message })
    }
})

module.exports = productRouter