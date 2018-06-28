import Vue from 'vue/dist/vue.esm'
import VueRouter from 'vue-router'
import PieChart from '../components/PieChart'

Vue.use(VueRouter)

document.addEventListener('turbolinks:load', () => {
  const pieChartElements = document.querySelectorAll('.vue-enable-pie-chart')

  pieChartElements.forEach((element) => {
    new Vue({
      el: element,

      components: {
        PieChart,
      },
    })
  })

  // TODO - Move this to a spot that makes sense after making it into a component
  const Students = {
    template: `
      <div class="tab-content" id="students">
        <h3>Students <span>2</span></h3>

        <p>[VUE CHARTS GO HERE]</p>
      </div>
    `
  }

  const Mentors = {
    template: `
      <div class="tab-content" id="mentors">
        <h3>Mentors <span>2</span></h3>

        <p>[VUE CHARTS GO HERE]</p>
      </div>
    `
  }

  const router = new VueRouter({
    base: '/admin/dashboard',
    routes: [
      { path: '/', redirect: { name: 'students' }},
      { path: '/students', name: 'students', component: Students },
      { path: '/mentors', name: 'mentors', component: Mentors }
    ]
  })

  new Vue({
    router,
    template: `
      <div class="tabs tabs-vertical grid" id="admin-dashboard">
        <ul class="tab-menu grid__col-4">
          <router-link
            tag="li"
            class="tab-link"
            active-class="tabs__menu-link--active"
            :to="{ name: 'students' }"
          >
            <button role="button" class="tab-button">
              Students
            </button>
          </router-link>

          <router-link
            tag="li"
            class="tab-link"
            active-class="tabs__menu-link--active"
            :to="{ name: 'mentors' }"
          >
            <button role="button" class="tab-button">
              Mentors
            </button>
          </router-link>
        </ul>

        <router-view class="content grid__col-8"></router-view>
      </div>
    `
  }).$mount('#admin-dashboard')
})
