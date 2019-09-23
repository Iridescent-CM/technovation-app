<template>
  <form class="panel panel--contains-bottom-bar panel--contains-top-bar">
    <div class="panel__top-bar">
      What is your birthdate?
    </div>

    <div class="panel__content grid">
      <div class="grid__col-7 grid__col--bleed">
        <label for="year">Year</label>
        <vue-select
          :select-on-tab="true"
          input-id="year"
          :options="years"
          v-model="year"
          :disabled="!!currentAccount"
        />

        <label for="month">Month</label>
        <vue-select
          :select-on-tab="true"
          input-id="month"
          :options="months"
          v-model="month"
          :disabled="!!currentAccount"
        />

        <label for="day">Day</label>
        <vue-select
          :select-on-tab="true"
          input-id="day"
          :options="days"
          v-model="day"
          :disabled="!!currentAccount"
        />
      </div>

      <div class="grid__col-5 grid__col--bleed padding--t-l-large">
        <dl v-if="age">
          <dt>Your age today</dt>
          <dd>You are <strong>{{ age }}</strong> years old.</dd>

          <dt class="margin--t-xlarge">Your age during World Pitch</dt>
          <dd>
            You will be <strong>{{ getAgeByCutoff }}</strong> on {{ cutoffDay }}.
          </dd>
        </dl>
      </div>

      <div class="grid__col-12 grid__col--bleed-x">
        <h4>Team divisions explained:</h4>

        <dl>
          <dt class="color--secondary">Junior Division</dt>
          <dd>
            Team members are between 10-14 years old as of {{ cutoffDay }}.
          </dd>

          <dt class="color--secondary">Senior Division</dt>
          <dd>
            Team members are between 15-18 years old as of {{ cutoffDay }}.
          </dd>
        </dl>
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
        type="submit"
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
import { createNamespacedHelpers } from 'vuex'
import VueSelect from 'vue-select'

const { mapGetters, mapActions, mapState } = createNamespacedHelpers('registration')
const { mapState: mapAuthState } = createNamespacedHelpers('authenticated')

export default {
  components: {
    VueSelect,
  },

  computed: {
    ...mapState(['months', 'birthMonth']),

    ...mapAuthState(['currentAccount']),

    ...mapGetters(['isAgeSet', 'getAge', 'getAgeByCutoff', 'getBirthdate']),

    profileChoice: {
      get () {
        return this.$store.state.registration.profileChoice
      },

      set (choice) {
        this.$store.commit('registration/profileChoice', choice)
      },
    },

    genderIdentity: {
      get () {
        return this.$store.state.registration.genderIdentity
      },

      set (identity) {
        this.$store.commit('registration/genderIdentity', identity)
      },
    },

    age () {
      return this.getAge()
    },

    nextStepEnabled () {
      return this.isAgeSet
    },

    year: {
      get () {
        return this.getBirthdate.split('-')[0]
      },

      set (year) {
        this.$store.commit('registration/birthYear', year)
      },
    },

    month: {
      get () {
        return this.birthMonth
      },

      set (month) {
        this.$store.commit('registration/birthMonth', month)
      },
    },

    day: {
      get () {
        return this.getBirthdate.split('-')[2]
      },

      set (day) {
        this.$store.commit('registration/birthDay', day)
      },
    },

    cutoffDay () {
      return "August 1, 2020"
    },

    divisionExplanation () {
      return "If you choose to be a student, and all of your teammates are " +
             "also under 15 before " + this.cutoffDay + ", " +
             "your team will be in the Junior Division."
    },

    years () {
      // making it reverse, highest number on top
      const endYear = new Date().getFullYear() - 110

      let startYear = endYear + 100
      let years = []

      while (startYear >= endYear) {
        years.push((startYear--).toString())
      }

      return years
    },

    days () {
      let startDay = 1
      let days = []

      while (startDay <= this.monthEndDay) {
        days.push((startDay++).toString())
      }

      return days
    },

    monthEndDay () {
      if (!this.month) return 31

      switch(parseInt(this.month.value)) {
        case 4:
        case 6:
        case 9:
        case 11: return 30

        case 2: return this.februaryEndDay

        default: return 31
      }
    },

    februaryEndDay () {
      const year = parseInt(this.year) || 0

      const isLeapYear = !!year && (year & 3) == 0 && (
        (year % 25) != 0 || (year & 15) == 0
      )

      if (!!year && !isLeapYear) {
        return 28
      } else {
        return 29
      }
    }
  },

  watch: {
    getAgeByCutoff (value) {
      if (value && value < 19 && this.genderIdentity !== 'Male') {
        this.profileChoice = 'student'
      } else if (value && value < 19 && this.genderIdentity === 'Male') {
        this.genderIdentity = null
      }
    },

    year (value) {
      this.updateBirthdate({ year: value, month: this.month, day: this.day })
    },

    month (value) {
      this.updateBirthdate({ year: this.year, month: value, day: this.day })
    },

    day (value) {
      this.updateBirthdate({ year: this.year, month: this.month, day: value })
    },
  },

  methods: {
    ...mapActions(['updateBirthdate']),

    handleSubmit () {
      if (!this.nextStepEnabled) return false
      this.$router.push({ name: 'choose-profile' })
    },

    navigateBack () {
      this.$router.push({ name: 'location' })
    },
  },
}
</script>

<style lang="scss" scoped>
label:not(:first-child) {
  margin: 2rem 0 0;
}
</style>