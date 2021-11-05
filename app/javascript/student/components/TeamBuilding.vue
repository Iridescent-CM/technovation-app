<template>
  <div :class="mainTabClass">
    <div :class="['tabs__content', mainContainerGridColumn]">
      <router-view :key="$route.name">
        <div slot="parental-consent"><slot name="parental-consent" /></div>
        <div slot="find-team"><slot name="find-team" /></div>
        <div slot="create-team"><slot name="create-team" /></div>
        <div slot="find-mentor"><slot name="find-mentor" /></div>
      </router-view>
    </div>

    <div class="grid__col-3" v-if="!embedded">
      <div class="tabs-menu__child-menu" v-sticky-sidebar="stickySidebarClasses">
        <team-menu />
      </div>
    </div>
  </div>
</template>

<script>
import StickySidebar from 'directives/sticky-sidebar'
import TeamMenu from 'student/menus/Team'

export default {
  name: 'team-building',

  data(){
    return{
      isStudentDash: false
    }
  },

  directives: {
    'sticky-sidebar': StickySidebar,
  },

  props: {
    stickySidebarClasses: {
      type: Array,
      default () {
        return []
      },
    },

    embedded: {
      type: Boolean,
      required: false,
      default: false,
    },
  },

  beforeMount() {
    let pathname = window.location.pathname
    if (pathname === '/student/dashboard') {
      this.isStudentDash = true
    }
  },

  computed: {
    mainContainerGridColumn () {
      if (this.embedded && !this.isStudentDash)
        return 'grid__col-12 tabs__content--embedded'

      if(!this.isStudentDash)
        return 'grid__col-9'
    },

    mainTabClass () {
      if(this.embedded && !this.isStudentDash){
        return 'tabs tabs--vertical tabs--css-only grid'
      }
    }
  },
}
</script>