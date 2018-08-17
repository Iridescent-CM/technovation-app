<template>
  <form class="panel panel--contains-bottom-bar panel--contains-top-bar">
    <div class="panel__top-bar">
      Basic Profile
    </div>

    <div class="panel__content">
      <div class="grid margin--b-xlarge">
        <div class="grid__col-6 grid__col--bleed">
          <label for="firstName">First name(s)</label>
          <input
            id="firstName"
            type="text"
            v-model="firstName"
          />
        </div>

        <div class="grid__col-6 grid__col--bleed-y padding--r-none">
          <label for="lastName">Last name(s)</label>
          <input
            id="lastName"
            type="text"
            v-model="lastName"
          />
        </div>
      </div>

      <p v-show="isGenderRequired">
        <label for="gender">Gender identity</label>
        <vue-select
          :select-on-tab="true"
          input-id="gender"
          :options="genderOptions"
          v-model="genderIdentity"
        />
      </p>

      <p>
        <label for="schoolName">{{ schoolCompanyNameLabel }}</label>
        <input
          v-if="profileChoice === 'student'"
          id="schoolName"
          type="text"
          v-model="schoolCompanyName"
        />

        <autocomplete-input
          v-else
          id="schoolName"
          v-model="schoolCompanyName"
          url="/registration/top_companies"
        />
      </p>

      <p v-show="profileChoice !== 'student'">
        <label for="jobTitle">Job Title</label>
        <input
          id="jobTitle"
          type="text"
          v-model="jobTitle"
        />
      </p>

      <p v-show="profileChoice !== 'student'">
        <label for="mentorType">As a mentor, you may call me a(n)...</label>
        <vue-select
          :select-on-tab="true"
          input-id="mentorType"
          :options="mentorTypeOptions"
          v-model="mentorType"
        />
      </p>

      <h4 v-show="profileChoice !== 'student'">Choose expertise(s)</h4>
      <p v-show="profileChoice !== 'student'">
        <span v-for="expertise in expertiseOptions" :key="expertise.value">
          <label :for="`mentor_profile_expertise_ids_${expertise.value}`">
            <span class="inline-checkbox">
              <input
                type="checkbox"
                :value="expertise.value"
                :id="`mentor_profile_expertise_ids_${expertise.value}`"
                v-model="expertises"
              >
            </span>
            {{ expertise.label }}
          </label>
        </span>
      </p>

      <p>
        <label for="referredBy">How did you hear about Technovation? (optional)</label>
        <vue-select
          :select-on-tab="true"
          input-id="referredBy"
          :options="referralOptions"
          v-model="referredBy"
        />

        <transition name="fade">
          <input
            id="referralOther"
            type="text"
            placeholder="Tell us here"
            v-show="referredBy === 'Other'"
            v-model="referredByOther"
          />
        </transition>
      </p>
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
import { debounce } from 'utilities/utilities'
import { mapState, mapGetters, mapActions } from 'vuex'
import VueSelect from '@vendorjs/vue-select'
import AutocompleteInput from 'components/AutocompleteInput'

export default {
  name: 'basic-profile',

  components: {
    AutocompleteInput,
    VueSelect,
  },

  data () {
    return {
      genderOptions: ['Female', 'Male', 'Non-binary', 'Prefer not to say'],
      referralOptions: [
        'Friend',
        'Colleague',
        'Article',
        'Internet',
        'Social media',
        'Print',
        'Web search',
        'Teacher',
        'Parent/family',
        'Company email',
        'Other',
      ],
      mentorTypeOptions: [
        'Industry professional',
        'Educator',
        'Parent',
        'Past Technovation student',
      ],
      expertiseOptions: [],
    }
  },

  beforeRouteEnter (_to, from, next) {
    next(vm => {
      if (vm.isAgeSet && vm.profileChoice !== null) {
        next()
      } else {
        vm.$router.replace(from.path)
      }
    })
  },

  created () {
    console.log('basicprofile created')
    this.debouncedProfileUpdate = debounce(attributes => {
      this.updateBasicProfile(attributes)
    }, 500)

    this.getExpertiseOptions()
  },

  computed: {
    ...mapState(['profileChoice']),

    ...mapGetters(['isAgeSet', 'isBasicProfileSet']),

    nextStepEnabled () {
      return this.isBasicProfileSet
    },

    isGenderRequired () {
      return this.profileChoice !== 'student'
    },

    schoolCompanyNameLabel () {
      if (this.profileChoice === 'student') {
        return 'School Name'
      } else {
        return 'School or Company Name'
      }
    },

    firstName: {
      get () {
        return this.$store.state.firstName
      },

      set (value) {
        this.$store.commit('firstName', value)
      },
    },

    lastName: {
      get () {
        return this.$store.state.lastName
      },

      set (value) {
        this.$store.commit('lastName', value)
      },
    },

    genderIdentity: {
      get () {
        return this.$store.state.genderIdentity
      },

      set (value) {
        this.$store.commit('genderIdentity', value)
      },
    },

    schoolCompanyName: {
      get () {
        return this.$store.state.schoolCompanyName
      },

      set (value) {
        this.$store.commit('schoolCompanyName', value)
      },
    },

    jobTitle: {
      get () {
        return this.$store.state.jobTitle
      },

      set (value) {
        this.$store.commit('jobTitle', value)
      },
    },

    mentorType: {
      get () {
        return this.$store.state.mentorType
      },

      set (value) {
        this.$store.commit('mentorType', value)
      },
    },

    expertises: {
      get () {
        return this.$store.state.expertiseIds
      },

      set (value) {
        this.$store.commit('expertiseIds', value)
      },
    },

    referredBy: {
      get () {
        return this.$store.state.referredBy
      },

      set (value) {
        this.$store.commit('referredBy', value)
      },
    },

    referredByOther: {
      get () {
        return this.$store.state.referredByOther
      },

      set (value) {
        this.$store.commit('referredByOther', value)
      },
    },
  },

  watch: {
    firstName (value) {
      this.debouncedProfileUpdate({ firstName: value })
    },

    lastName (value) {
      this.debouncedProfileUpdate({ lastName: value })
    },

    genderIdentity (value) {
      this.debouncedProfileUpdate({ genderIdentity: value })
    },

    schoolCompanyName (value) {
      this.debouncedProfileUpdate({ schoolCompanyName: value })
    },

    jobTitle (value) {
      this.debouncedProfileUpdate({ jobTitle: value })
    },

    mentorType (value) {
      this.debouncedProfileUpdate({ mentorType: value })
    },

    expertises (value) {
      this.debouncedProfileUpdate({ expertiseIds: value })
    },

    referredBy (value) {
      this.debouncedProfileUpdate({ referredBy: value })
    },

    referredByOther (value) {
      this.debouncedProfileUpdate({ referredByOther: value })
    },
  },

  methods: {
    ...mapActions(['updateBasicProfile']),

    handleSubmit () {
      if (!this.nextStepEnabled) return false
      this.$router.push({ name: 'login' })
    },

    getExpertiseOptions () {
      if (this.expertiseOptions.length === 0) {
        window.axios.get('/registration/expertises')
          .then(({ data: { attributes } }) => {
            attributes.forEach((expertise) => {
              this.expertiseOptions.push({
                label: expertise.name,
                value: expertise.id,
              })
            })
          })
          .catch(err => console.error(err))
      }
    },

    navigateBack () {
      this.$router.push({ name: 'choose-profile' })
    },
  },
}
</script>

<style lang="scss" scoped>
p {
  margin: 0 0 2rem;
}

#referralOther {
  margin-top: 0.5rem;
  width: 50%;
}
</style>