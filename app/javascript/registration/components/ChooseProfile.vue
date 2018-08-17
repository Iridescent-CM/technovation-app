<template>
  <form class="panel panel--contains-bottom-bar panel--contains-top-bar">
    <div class="panel__top-bar">
      Choose your profile type
    </div>

    <div class="panel__content">
      Due to your age, you can be a:

      <div class="grid grid--justify-space-around">
        <div
          :class="[
            'opacity--50',
            'hover--opacity-75',
            getCSSForOption(option)
          ]"
          v-for="option in profileOptions"
          :key="option"
        >
          <label class="text-align--center">
            <img :src="getProfileIconSrc(option)" />

            <input
              type="radio"
              name="profileChoice"
              v-model="profileChoice"
              :value="option"
            />
            {{ option }}
          </label>
        </div>
      </div>
    </div>

    <div class="panel__bottom-bar">
      <a
        class="button float--left"
        @click.prevent="navigateBack"
      >
        Back
      </a>
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

export default {
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
    ...mapState(['months', 'birthMonth', 'genderIdentity']),

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

        case (this.genderIdentity !== 'Male' && this.getAge() < 14): {
          this.profileChoice = 'student'
          return ['student']
        }

        case (this.getAgeByCutoff > 18):
          this.profileChoice = 'mentor'
          return ['mentor']

        case (this.genderIdentity !== 'Male' && this.getAge() >= 14 && this.getAgeByCutoff < 19):
          this.profileChoice = 'student'
          return ['mentor', 'student']
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

    getProfileIconSrc (choice) {
      if (choice) {
        const elem = document.getElementById('vue-data-registration')
        const capitalizedChoice = choice.charAt(0).toUpperCase() + choice.slice(1)

        if (choice === 'mentor' && this.$store.state.genderIdentity === 'Male') {
          return elem.dataset.profileIconMentorMale
        } else {
          return elem.dataset[`profileIcon${capitalizedChoice}`]
        }
      } else {
        return ''
      }
    },

    getCSSForOption (option) {
      if (this.profileOptions.length === 1)
        return 'opacity--100 grid__col-6'

      if (this.profileChoice === option)
        return 'opacity--100 grid__col-auto'

      return 'grid__col-auto'
    },
  },
}
</script>

<style lang="scss" scoped>
label:not(:first-child) {
  margin: 2rem 0 0;
}
</style>