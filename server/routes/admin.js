const express = require('express')
const adminRouter = express.Router()
const admin = require('../middlewares/admin')
const { Product } = require('../models/product')
const Order = require('../models/order')

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

//get all products
adminRouter.get('/admin/get-products', admin, async (req, res) => {
    try {
        //get all products
        const products = await Product.find({})
        res.json(products)

    } catch (error) {
        res.status(500).json({ error: error.message })
    }
})

//delete product by id
adminRouter.post('/admin/delete-product', admin, async (req, res) => {
    try {
        const { id } = req.body
        let product = await Product.findByIdAndDelete(id)
        res.json(product)
    } catch (error) {
        res.status(500).json({ error: error.message })
    }
})

adminRouter.get('/admin/get-orders', admin, async (req, res) => {
    try {
        const orders = await Order.find({})
        res.json(orders)
    } catch (error) {
        res.status(500).json({ error: error.message })
    }
})


//change order status
adminRouter.post('/admin/change-order-status', admin, async (req, res) => {
    try {
        const { id, status } = req.body
        let order = await Order.findById(id)
        order.status = status
        order = await order.save()
        res.json(order)
    } catch (error) {
        res.status(500).json({ error: error.message })
    }
})

module.exports = adminRouter