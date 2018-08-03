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
          input-id="gender"
          :options="genderOptions"
          v-model="genderIdentity"
        />
      </p>

      <p>
        <label for="schoolName">{{ schoolCompanyNameLabel }}</label>
        <input
          v-if="getProfileChoice === 'student'"
          id="schoolName"
          type="text"
          v-model="schoolCompanyName"
        />

        <autocomplete-input
          v-else
          id="schoolName"
          v-model="schoolCompanyName"
          url="/public/top_companies"
        />
      </p>

      <p>
        <label for="referredBy">How did you hear about Technovation? (optional)</label>
        <vue-select
          input-id="referredBy"
          :options="referralOptions"
          v-model="referredBy"
        />

        <input
          id="referralOther"
          type="text"
          placeholder="Tell us here"
          v-show="referredBy === 'Other'"
          v-model="referredByOther"
        />
      </p>
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
import debounce from 'lodash/debounce'
import { mapGetters, mapActions } from 'vuex'
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
        "Friend",
        "Colleague",
        "Article",
        "Internet",
        "Social media",
        "Print",
        "Web search",
        "Teacher",
        "Parent/family",
        "Company email",
        "Other",
      ],
    }
  },

  created () {
    this.debouncedProfileUpdate = debounce(attrs => {
      const attributes = Object.assign({},
        {
          firstName: this.firstName,
          lastName: this.lastName,
          genderIdentity: this.genderIdentity,
          schoolCompanyName: this.schoolCompanyName,
          referredBy: this.referredBy,
          referredByOther: this.referredByOther,
        }, attrs)

      this.updateBasicProfile(attributes)
    }, 500)
  },

  computed: {
    ...mapGetters([
      'getFirstName',
      'getLastName',
      'getGenderIdentity',
      'getSchoolCompanyName',
      'getReferredBy',
      'getReferredByOther',
      'getProfileChoice',
    ]),

    nextStepEnabled () {
      return !!this.firstName &&
              !!this.lastName &&
                (this.isGenderRequired && !!this.genderIdentity) &&
                  !!this.schoolCompanyName
    },

    isGenderRequired () {
      return this.getProfileChoice != 'student'
    },

    schoolCompanyNameLabel () {
      if (this.getProfileChoice == 'student') {
        return "School Name"
      } else {
        return "School or Company Name"
      }
    },

    firstName: {
      get () {
        return this.getFirstName
      },

      set (value) {
        this.$store.commit('firstName', value)
      },
    },

    lastName: {
      get () {
        return this.getLastName
      },

      set (value) {
        this.$store.commit('lastName', value)
      },
    },

    genderIdentity: {
      get () {
        return this.getGenderIdentity
      },

      set (value) {
        this.$store.commit('genderIdentity', value)
      },
    },

    schoolCompanyName: {
      get () {
        return this.getSchoolCompanyName
      },

      set (value) {
        this.$store.commit('schoolCompanyName', value)
      },
    },

    referredBy: {
      get () {
        return this.getReferredBy
      },

      set (value) {
        this.$store.commit('referredBy', value)
      },
    },

    referredByOther: {
      get () {
        return this.getReferredByOther
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