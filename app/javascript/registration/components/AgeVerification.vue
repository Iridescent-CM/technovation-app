<template>
  <form class="panel panel--contains-bottom-bar panel--contains-top-bar">
    <div class="panel__top-bar">
      What is your birthdate?
    </div>

    <div class="panel__content">
      <label for="year">Year</label>
      <autocomplete-input
        id="year"
        :options="years"
        v-model="year"
      />

      <label for="month">Month</label>
      <autocomplete-input
        id="month"
        :options="months"
        v-model="month"
      />

      <label for="day">Day</label>
      <autocomplete-input
        id="day"
        :options="days"
        v-model="day"
      />

      <div v-if="age">
        <p>You are <strong>{{ age }}</strong> years old.</p>

        <p>
          You will be <strong>{{ ageByCutoff }}</strong> before {{ cutoffDay }}.
        </p>
      </div>

      <h4>Team divisions explained:</h4>

      <dl>
        <dt>Junior Division Teams</dt>
        <dd>All students on the team will be younger than 15 before {{ cutoffDay }}</dd>

        <dt>Senior Division Teams</dt>
        <dd>One student on the team will be 15 or older before {{ cutoffDay }}</dd>
      </dl>
    </div>

    <div class="panel__bottom-bar">
      next...
    </div>
  </form>
</template>

<script>
import AutocompleteInput from 'components/AutocompleteInput'

export default {
  components: {
    AutocompleteInput,
  },

  data () {
    return {
      year: '',
      month: '',
      day: '',
    }
  },

  computed: {
    age () {
      return this.getAge(new Date())
    },

    ageByCutoff () {
      return this.getAge(new Date("2019-08-01"))
    },

    cutoffDay () {
      return "the first day of August 2019"
    },

    profileChoices () {
      return "a student or a mentor"
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

    months () {
      return [
        { label: "01 - January", value: "1" },
        { label: "02 - February", value: "2" },
        { label: "03 - March", value: "3" },
        { label: "04 - April", value: "4" },
        { label: "05 - May", value: "5" },
        { label: "06 - June", value: "6" },
        { label: "07 - July", value: "7" },
        { label: "08 - August", value: "8" },
        { label: "09 - September", value: "9" },
        { label: "10 - October", value: "10" },
        { label: "11 - November", value: "11" },
        { label: "12 - December", value: "12" },
      ]
    },

    days () {
      const endDay = 31
      let startDay = 1
      let days = []

      while (startDay <= endDay) {
        days.push((startDay++).toString())
      }

      return days
    },
  },

  methods: {
    getAge (compareDate) {
      const year = parseInt(this.year)
      const month = parseInt(this.month)
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