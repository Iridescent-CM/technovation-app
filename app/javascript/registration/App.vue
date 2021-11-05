<template>
  <div :class="wrapperClasses">
    <div :class="mainContainerGridColumn">
      <transition name="router-fade">
        <router-view v-if="isReady" :key="$route.path" :profile-icons="profileIcons">
          <div slot="change-email"><slot name="change-email" /></div>
          <div slot="change-password"><slot name="change-password" /></div>
        </router-view>
      </transition>
    </div>

    <div :class="menuGridColumn" v-if="!embedded">
      <div v-sticky-sidebar="stickySidebarClasses">
        <dashboard-menu />
      </div>
    </div>
  </div>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'

import StickySidebar from 'directives/sticky-sidebar'
import DashboardMenu from './DashboardMenu'

const { mapState } = createNamespacedHelpers('registration')

export default {
  name: 'app',

  data () {
    return{
      isSignup: false
    }
  },

  directives: {
    'sticky-sidebar': StickySidebar,
  },

  components: {
    DashboardMenu,
  },

  props: {
    removeWhiteBackground: {
      type: Boolean,
      default: true,
    },

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

    profileIcons: {
      type: Object,
      default () {
        return {
          profileIconMentor: '',
          profileIconMentorMale: '',
          profileIconStudent: '',
        }
      },
    },
  },

  computed: {
    ...mapState([
      'isReady',
    ]),

    beforeMount() {
      let pathname = window.location.pathname
      if (pathname === '/signup') {
        this.isSignup = true
      }
    },

    mainContainerGridColumn () {
      if (this.embedded && this.isSignup)
        return "grid__col-12"

      return "grid__col-9"
    },

    menuGridColumn () {
      if (this.embedded)
        return ''

      if(this.isSignup)
        return 'grid__col-3 grid__col--bleed'
    },

    wrapperClasses () {
      if(this.isSignup){
        return {
          grid: true,
          tabs: true,
          'tabs--vertical': true,
          'tabs--remove-bg': this.removeWhiteBackground,
          'tabs--css-only': true,
        }
      }
    },
  },
}
</script>

<style lang="scss" scoped>
</style>
