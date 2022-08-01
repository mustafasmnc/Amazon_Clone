const express = require('express')
const adminRouter = express.Router()
const admin = require('../middlewares/admin')
const Product = require('../models/product')

//add product
adminRouter.post('/admin/add-product', admin, async (req, res) => {
    try {
        const { name, description, price, quantity, images, category } = req.body
        let product = new Product({
            name,
            description,
            price,
            quantity,
            images,
            category,
        })
        product = await product.save()
        res.json(product)
    } catch (error) {
        res.status(500).json({ error: e.message })
    }
})

module.exports = adminRouter