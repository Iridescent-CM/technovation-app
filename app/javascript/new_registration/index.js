import Vue from 'vue'
import App from './App'

document.addEventListener('DOMContentLoaded', () => {
    console.log("new registration js");
    const app = new Vue({
        render: h => h(App)
    }).$mount()
    document.body.appendChild(app.$el)
    console.log("test")
    console.log(app)
})