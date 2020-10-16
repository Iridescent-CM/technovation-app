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

      <p class="section" v-show="isGenderRequired">
        <label for="gender">Gender identity</label>
        <vue-select
          :select-on-tab="true"
          input-id="gender"
          :options="genderOptions"
          v-model="genderIdentity"
        />
      </p>

      <p class="section">
        <label for="schoolName">{{ schoolCompanyNameLabel }}</label>
        <input
          id="schoolName"
          type="text"
          v-model="schoolCompanyName"
        />
      </p>

      <div v-show="profileChoice == 'mentor'">
        <p class="section">
          <label for="jobTitle">Job title</label>
          <input
            id="jobTitle"
            type="text"
            v-model="jobTitle"
          />
        </p>

        <p class="section">
          <label for="mentorType">As a mentor, you may call me a(n)...</label>
          <vue-select
            :select-on-tab="true"
            input-id="mentorType"
            :options="mentorTypeOptions"
            v-model="mentorType"
          />
        </p>

        <h4>Skills &amp; Interests</h4>
        <p class="section">
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

        <div class="section">
          <h4>Set your personal summary</h4>
          <p>
            Add a description of yourself to your profile to help students get to know
            you. You can change this later.
          </p>
          <label for="bio">
            Tell the students about yourself
          </label>
          <textarea
            id="bio"
            v-model="bio"
          >
          </textarea>
          <p class="word-count">
            {{ bio.length }}
            {{ bio.length | pluralize('character') }}
          </p>
          <p class="hint">
            Please provide at least 100 characters, or about 15 words
          </p>
        </div>
      </div>

      <p class="section">
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
        v-if="!embedded"
        :disabled="!nextStepEnabled"
        @click.prevent="handleSubmit"
      >
        Next
      </button>

      <button v-else class="button button--remove-bg pointer-events--none">
        &nbsp;{{ saveLabel }}
      </button>
    </div>
  </form>
</template>

<script>
import { createNamespacedHelpers } from 'vuex'
import VueSelect from 'vue-select'

import { debounce } from 'utilities/utilities'

const { mapState, mapGetters, mapActions } = createNamespacedHelpers('registration')

export default {
  name: 'basic-profile',

  components: {
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
      saving: false,
      saved: false,
    }
  },

  props: {
    embedded: {
      type: Boolean,
      required: false,
      default: false,
    },
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
    this.debouncedProfileUpdate = debounce(attributes => {
      if (this.embedded) {
        this.saving = true
        this.saved = false
      }

      this.updateBasicProfile(attributes).then(() => {
        if (this.embedded) {
          this.saving = false
          this.saved = true
        }
      })
    }, 500)

    this.getExpertiseOptions()
  },

  computed: {
    ...mapState(['profileChoice']),

    ...mapGetters(['isAgeSet', 'isBasicProfileSet']),

    nextStepEnabled () {
      return this.isBasicProfileSet
    },

    saveLabel () {
      if (this.saved)
        return 'All your changes have been saved!'

      if (this.saving)
        return 'Saving...'

      return ''
    },

    isGenderRequired () {
      return this.profileChoice !== 'student'
    },

    schoolCompanyNameLabel () {
      if (this.profileChoice === 'student') {
        return 'School name'
      } else {
        return 'School or company name'
      }
    },

    firstName: {
      get () {
        return this.$store.state.registration.firstName
      },

      set (value) {
        this.handleDataChanges('registration/firstName', value)
      },
    },

    lastName: {
      get () {
        return this.$store.state.registration.lastName
      },

      set (value) {
        this.handleDataChanges('registration/lastName', value)
      },
    },

    genderIdentity: {
      get () {
        return this.$store.state.registration.genderIdentity
      },

      set (value) {
        this.handleDataChanges('registration/genderIdentity', value)
      },
    },

    schoolCompanyName: {
      get () {
        return this.$store.state.registration.schoolCompanyName
      },

      set (value) {
        this.handleDataChanges('registration/schoolCompanyName', value)
      },
    },

    jobTitle: {
      get () {
        return this.$store.state.registration.jobTitle
      },

      set (value) {
        this.handleDataChanges('registration/jobTitle', value)
      },
    },

    mentorType: {
      get () {
        return this.$store.state.registration.mentorType
      },

      set (value) {
        this.handleDataChanges('registration/mentorType', value)
      },
    },

    expertises: {
      get () {
        return this.$store.state.registration.expertiseIds
      },

      set (value) {
        this.handleDataChanges('registration/expertiseIds', value)
      },
    },

    bio: {
      get () {
        return this.$store.state.registration.bio || ""
      },

      set (value) {
        this.handleDataChanges('registration/bio', value)
      },
    },

    referredBy: {
      get () {
        return this.$store.state.registration.referredBy
      },

      set (value) {
        this.handleDataChanges('registration/referredBy', value)
      },
    },

    referredByOther: {
      get () {
        return this.$store.state.registration.referredByOther
      },

      set (value) {
        this.handleDataChanges('registration/referredByOther', value)
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

    bio (value) {
      this.debouncedProfileUpdate({ bio: value })
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

    handleDataChanges (mutation, value) {
      this.$store.commit(mutation, value)
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
.section {
  margin: 0 0 2rem;
}

#referralOther {
  margin-top: 0.5rem;
  width: 50%;
}
</style>
