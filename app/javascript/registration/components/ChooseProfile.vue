<template>
  <form class="panel panel--contains-bottom-bar panel--contains-top-bar">
    <div class="panel__top-bar">
      What is your birthdate?
    </div>

    <div class="panel__content grid">
      <div class="grid__col-12 grid__col--bleed-x">
        <h4>Profile choice</h4>

        I want to sign up as a:

        <ul class="margin--t-b-large margin--r-l-none padding--none list-style--none">
          <li v-for="option in profileOptions" :key="option">
            <label>
              <input
                type="radio"
                name="profileChoice"
                v-model="profileChoice"
                :value="option"
              />
              {{ option }}
            </label>
          </li>
        </ul>
      </div>
    </div>

    <div class="panel__bottom-bar">
      <button
        class="button float--left"
        @click.prevent="navigateBack"
      >
        Back
      </button>
      <button
        class="button"
        :disabled="!nextStepEnabled"
        @click.prevent="handleSubmit"
      >
        Next
      </button>
    </div>
  </form>
</template>

<script>
import { mapGetters, mapActions, mapState } from 'vuex'
import VueSelect from '@vendorjs/vue-select'

export default {
  components: {
    VueSelect,
  },

  beforeRouteEnter (_to, from, next) {
    next(vm => {
      if (vm.isAgeSet) {
        next()
      } else {
        vm.$router.replace(from.path)
      }
    })
  },

  computed: {
    ...mapState(['months', 'birthMonth']),

    ...mapGetters(['getAge', 'getAgeByCutoff', 'isAgeSet', 'getBirthdate']),

    nextStepEnabled () {
      return this.isAgeSet && !!this.profileChoice
    },

    profileChoice: {
      get () {
        return this.$store.state.profileChoice
      },

      set (choice) {
        this.$store.commit('profileChoice', choice)
      },
    },

    profileOptions () {
      switch(true) {
        case (!this.getAge()):
          return []

        case (this.getAge() < 14):
          return ['student']

        case (this.getAge() >= 14 && this.getAgeByCutoff < 19):
          return ['student', 'mentor']

        case (this.getAgeByCutoff > 18):
          return ['mentor']
      }
    },
  },

  watch: {
    profileChoice (value) {
      this.updateProfileChoice(value)
    },

    profileOptions (arr) {
      if (arr.length === 1) this.profileChoice = arr[0]
    },
  },

  methods: {
    ...mapActions(['updateProfileChoice']),

    handleSubmit () {
      if (!this.nextStepEnabled) return false
      this.$router.push({ name: 'basic-profile' })
    },

    navigateBack () {
      this.$router.push({ name: 'age' })
    },
  },
}
</script>

<style lang="scss" scoped>
label:not(:first-child) {
  margin: 2rem 0 0;
}
</style>