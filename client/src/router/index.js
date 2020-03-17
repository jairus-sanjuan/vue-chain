import Vue from 'vue'
import VueRouter from 'vue-router'
import Products from '../views/Products.vue'
import Product from '../views/Product.vue'
import Participants from '../views/Participants.vue'
import Home from '../views/Home.vue'
Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/products',
    name: 'Products',
    component: Products
  },
  {
    path: '/product',
    name: 'Product',
    component: Product
  },
  {
    path: '/participants',
    name: 'Participants',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: Participants
  }
]

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
})

// router.beforeEach((to,from, next))=>{
//   condition here
// }

export default router
