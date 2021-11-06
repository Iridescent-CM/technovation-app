<template>
  <div :class=mainVerticalTabsClass>
    <div :class=tabClass>
      <div :class=gridClass>
        <div :class=gridEightClass>
          <slot name="events" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'events',

  data () {
    return {
      isStudentDash: false
    }
  },

  beforeMount() {
    let pathname = window.location.pathname
    if (pathname === '/student/dashboard') {
      this.isStudentDash = true
    }
  },

  computed: {
    mainVerticalTabsClass () {
      if(!this.isStudentDash){
        return 'tabs tabs--vertical tabs--css-only grid'
      }
    },

    gridClass () {
      if(!this.isStudentDash){
        return 'grid'
      }
    },

    gridEightClass () {
      if(!this.isStudentDash){
        return 'grid__col-8'
      }
    },

    tabClass () {
      if(!this.isStudentDash){
        return 'tabs__content grid__col-12 tabs__content--embedded'
      }
    }
  }
}
</script>