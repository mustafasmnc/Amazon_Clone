# Amazon Clone

Full Stack Amazon Clone along with Admin Panel

## Features
- Email & Password Authentication
- Persisting Auth State
- Searching Products
- Filtering Products (Based on Category)
- Product Details
- Rating
- Getting Deal of the Day
- Cart
- Checking out with Google/Apple Pay
- Viewing My Orders
- Viewing Order Details & Status
- Sign Out
- Admin Panel
    - Viewing All Products
    - Adding Products
    - Deleting Products
    - Viewing Orders
    - Changing Order Status
    - Viewing Total Earnings
    - Viewing Category Based Earnings (on Graph)


## Running Locally
After cloning this repository, migrate to ```flutter-amazon-clone-tutorial``` folder. Then, follow the following steps:
- Create MongoDB Project & Cluster
- Click on Connect, follow the process where you will get the uri.- Replace the MongoDB uri with yours in ```server/.env``` file with MONGO_DB variable name.
- Head to ```.env``` file, replace <yourip> with your IP Address with SEVERURI variable name. 
- Create Cloudinary Project, enable unsigned operation in settings.
- Head to ```.env``` file, add CloudinaryApiKey, CloudinaryApiSecret and CloudinaryCloudName 

Then run the following commands to run your app:

### Server Side
```bash
  cd server
  npm install
  npm run dev (for continuous development)
  OR
  npm start (to run script 1 time)
```

### Client Side
```bash
  flutter pub get
  open -a simulator (to get iOS Simulator)
  flutter run
```

## Tech Used
**Server**: Node.js, Express, Mongoose, MongoDB, Cloudinary

**Client**: Flutter, Provider
    
## SreenShots
# User
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/auth.jpg" alt="auth" title="auth" width="200">|
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/home.jpg" alt="home" title="home" width="200">|
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/product.jpg" alt="product" title="product" width="200">|
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/search.jpg" alt="search" title="search" width="200">|
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/user_screen.jpg" alt="user_screen" title="user_screen" width="200">|
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/cart.jpg" alt="cart" title="cart" width="200">|
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/order_detail.jpg" alt="order_detail" title="order_detail" width="200">|

# Admin
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/admin_home.jpg" alt="admin_home" title="admin_home" width="200">|
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/admin_orders.jpg" alt="admin_orders" title="admin_orders" width="200">|
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/admin_order_detail.jpg" alt="admin_order_detail" title="admin_order_detail" width="200">|
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/admin_analytics.jpg" alt="admin_analytics" title="admin_analytics" width="200">|
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/admin_add_product.jpg" alt="admin_add_product" title="admin_add_product" width="200">|
<img src="https://github.com/mustafasmnc/Amazon_Clone/blob/main/assets/sc/admin_add_product_image.jpg" alt="admin_add_product_image" title="admin_add_product_image" width="200">