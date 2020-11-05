import Vue from 'vue'
import VueRouter from 'vue-router'
import App from './App.vue'

// Functional component
import User from './components/User'

// Graphical component
import Registration from './components/Register'
import Authentication from './components/Authentication'
import Dashboard from './components/Dashboard'
import WorkingTimes from './components/WorkingTimes'
import WorkingTime from './components/WorkingTime'
import ClockManager from './components/ClockManager'
import ChartManager from './components/ChartManager'
import UserAccount from './components/UserAccount'

import Notifications from 'vue-notification'
Vue.use(Notifications)

import { BootstrapVue, IconsPlugin } from 'bootstrap-vue'
Vue.use(BootstrapVue)
Vue.use(IconsPlugin)

Vue.config.productionTip = false
Vue.use(VueRouter);

const router = new VueRouter({
    mode: 'history',
    routes: [
        {
            path: '/',
            name: 'home',
            component: Authentication
        },
        // Sign_up (Registration) route
        {
            path: '/sign_up',
            name: 'signUp',
            component: Registration
        },
        // Sign_in (Authentication) route
        {
            path: '/sign_in',
            name: 'signIn',
            component: Authentication
        },
        // Dashboard route
        {
            path: '/dashboard',
            name: 'dashboard',
            component: Dashboard,
            meta: { requiresAuth: true }
        },
        // WorkingTimes route
        {
            path: '/workingTimes/:userid',
            name: 'workingTimes',
            component: WorkingTimes,
            meta: { requiresAuth: true }
        },
        // WorkingTime (creation) route
        {
            path: '/workingTime/:userid',
            name: 'workingTime_creation',
            component: WorkingTime,
            meta: { requiresAuth: true }
        },
        // WorkingTime (update & delete) route
        {
            path: '/workingTime/:userid/:workingtimeid',
            name: 'workingTime_update_delete',
            component: WorkingTime,
            meta: { requiresAuth: true }
        },
        // ClockManager route
        {
            path: '/clock/:username',
            name: 'clock',
            component: ClockManager,
            meta: { requiresAuth: true }
        },
        // ChartManager route
        {
            path: '/chartManager/:userid',
            name: 'chartManager',
            component: ChartManager,
            meta: { requiresAuth: true }
        },
        // UserAccount route
        {
            path: '/my_account',
            name: 'myAccount',
            component: UserAccount,
            meta: { requiresAuth: true }
        }
    ]
})

// Redirect to /sign_in if the route need an authentication and the
// user is not logged in. Redirect to the good route if it doesn't need
// one, or the user is logged in.
router.beforeEach((to, from, next) => { 
    if (to.meta.requiresAuth) { 
        if (!User.methods.isUserAuthenticated()) { 
            next({ path: '/sign_in'}) 
        } else { 
            //check codition is true
            next() 
        } 
    } else { 
        next() // make sure to always call next()! 
    } 
}) 

Vue.component('User', User);

new Vue({
    router,
    //store,
    render: h => h(App)
}).$mount('#app')