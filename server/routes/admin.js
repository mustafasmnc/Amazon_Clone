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

adminRouter.get('/admin/analytics', admin, async (req, res) => {
    try {
        const orders = await Order.find({})
        let totalEarnings = 0
        for (let i = 0; i < orders.length; i++) {
            for (let j = 0; j < orders[i].products.length; j++) {
                totalEarnings += orders[i].products[j].quantity * orders[i].products[j].product.price
            }

        }

        //Category wise order fetching
        let mobileEarnings = await fetchCategoryWiseProduct('Mobiles')
        let essentialEarnings = await fetchCategoryWiseProduct('Essentials')
        let applianceEarnings = await fetchCategoryWiseProduct('Appliances')
        let bookEarnings = await fetchCategoryWiseProduct('Books')
        let fashionEarnings = await fetchCategoryWiseProduct('Fashion')

        let earnings = {
            totalEarnings,
            mobileEarnings,
            essentialEarnings,
            applianceEarnings,
            bookEarnings,
            fashionEarnings,
        }

        res.json(earnings)

    } catch (error) {
        res.status(500).json({ error: error.message })
    }
})

async function fetchCategoryWiseProduct(category) {
    let earnings = 0
    let categoryOrders = await Order.find({
        'products.product.category': category,
    })

    for (let i = 0; i < categoryOrders.length; i++) {
        for (let j = 0; j < categoryOrders[i].products.length; j++) {
            earnings += categoryOrders[i].products[j].quantity * categoryOrders[i].products[j].product.price
        }

    }

    return earnings
}

module.exports = adminRouter