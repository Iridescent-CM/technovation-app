<template>
  <form class="panel panel--contains-bottom-bar panel--contains-top-bar">
    <div class="panel__top-bar">
      What is your birthdate?
    </div>

    <div class="panel__content grid">
      <div class="grid__col-7 grid__col--bleed">
        <label for="year">Year</label>
        <vue-select
          input-id="year"
          :options="years"
          v-model="year"
        />

        <label for="month">Month</label>
        <vue-select
          input-id="month"
          :options="months"
          v-model="month"
        />

        <label for="day">Day</label>
        <vue-select
          input-id="day"
          :options="days"
          v-model="day"
        />
      </div>

      <div class="grid__col-5 grid__col--bleed padding--t-l-large">
        <dl v-if="age">
          <dt>Your age today</dt>
          <dd>You are <strong>{{ age }}</strong> years old.</dd>

          <dt class="margin--t-xlarge">Your age during World Pitch</dt>
          <dd>
            You will be <strong>{{ ageByCutoff }}</strong> on {{ cutoffDay }}.
          </dd>
        </dl>
      </div>

      <div class="grid__col-12 grid__col--bleed-x">
        <h4>Team divisions explained:</h4>

        <dl>
          <dt class="color--secondary">Junior Division Teams</dt>
          <dd>
            <strong>All</strong> students on the team will be
            <strong>younger than 15</strong> on {{ cutoffDay }}
          </dd>

          <dt class="color--secondary">Senior Division Teams</dt>
          <dd>
            <strong>At least one</strong> student on your team will be
            <strong>15 or older</strong> on {{ cutoffDay }}
          </dd>
        </dl>
      </div>

      <div v-if="age" class="grid__col-12 grid__col--bleed-x">
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

  computed: {
    ...mapState(['months', 'birthMonth']),

    ...mapGetters(['getBirthdate']),

    nextStepEnabled () {
      return !!this.year && !!this.month && !!this.day && !!this.profileChoice
    },

    year: {
      get () {
        return this.getBirthdate.split('-')[0]
      },

      set (year) {
        this.$store.commit('birthYear', year)
      },
    },

    month: {
      get () {
        return this.birthMonth
      },

      set (month) {
        this.$store.commit('birthMonth', month)
      },
    },

    day: {
      get () {
        return this.getBirthdate.split('-')[2]
      },

      set (day) {
        this.$store.commit('birthDay', day)
      },
    },

    profileChoice: {
      get () {
        return this.$store.state.profileChoice
      },

      set (choice) {
        this.$store.commit('profileChoice', choice)
      },
    },

    age () {
      return this.getAge(new Date())
    },

    ageByCutoff () {
      return this.getAge(new Date("2019-08-01"))
    },

    cutoffDay () {
      return "August 1, 2019"
    },

    profileOptions () {
      switch(true) {
        case (!this.age):
          return []

        case (this.age < 14):
          return ['student']

        case (this.age >= 14 && this.ageByCutoff < 19):
          return ['student', 'mentor']

        case (this.ageByCutoff > 18):
          return ['mentor']
      }
    },

    canBeAStudent () {
      return true
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
    year (value) {
      this.updateBirthdate({ year: value, month: this.month, day: this.day })
    },

    month (value) {
      this.updateBirthdate({ year: this.year, month: value, day: this.day })
    },

    day (value) {
      this.updateBirthdate({ year: this.year, month: this.month, day: value })
    },

    profileChoice (value) {
      this.updateProfileChoice(value)
    },

    profileOptions (arr) {
      if (arr.length === 1) this.profileChoice = arr[0]
    },
  },

  methods: {
    ...mapActions(['updateBirthdate', 'updateProfileChoice']),

    handleSubmit () {
      if (!this.nextStepEnabled) return false
      this.$router.push({ name: 'location' })
    },

    getAge (compareDate) {
      const year = parseInt(this.year)
      const month = parseInt(Object.assign({}, this.month).value)
      const day = parseInt(this.day)

      if (!year || !month || !day) return false

      const compareYear = compareDate.getFullYear()
      const compareMonth = compareDate.getMonth() + 1
      const compareDay = compareDate.getDate()

      const extraYear = (
        compareMonth > month ||
          (compareMonth === month && compareDay >= day)
      ) ? 0 : 1

      return compareYear - year - extraYear
    },
  },
}
</script>

<style lang="scss" scoped>
label:not(:first-child) {
  margin: 2rem 0 0;
}
</style>