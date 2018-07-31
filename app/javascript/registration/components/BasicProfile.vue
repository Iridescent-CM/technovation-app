<template>
  <form class="panel panel--contains-bottom-bar panel--contains-top-bar">
    <div class="panel__top-bar">
      Basic Profile
    </div>

    <div class="panel__content">
      <div class="grid">
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

      <p>
        <label for="gender">Gender identity</label>
        <vue-select
          input-id="gender"
          :options="genderOptions"
          v-model="genderIdentity"
        />
      </p>

      <p>
        <label for="schoolName">School name</label>
        <input
          id="schoolName"
          type="text"
          v-model="schoolCompanyName"
        />
      </p>

      <p>
        <label for="referredBy">How did you hear about Technovation? (optional)</label>
        <vue-select
          input-id="referredBy"
          :options="referralOptions"
          v-model="referredBy"
        />
      </p>

      <p>
        <input
          ref="referralOther"
          type="text"
          placeholder="Tell us here"
          v-show="referredBy === 'Other'"
          v-model="referredByOther"
        />
      </p>
    </div>

    <div class="panel__bottom-bar">
      next...
    </div>
  </form>
</template>

<script>
import debounce from 'lodash/debounce'
import { mapGetters, mapActions } from 'vuex'
import VueSelect from '@vendorjs/vue-select'

export default {
  name: 'basic-profile',

  components: {
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
      const attributes = Object.assign({}, {
        firstName:         this.firstName,
        lastName:          this.lastName,
        genderIdentity:    this.genderIdentity,
        schoolCompanyName: this.schoolCompanyName,
        referredBy:        this.referredBy,
        referredByOther:   this.referredByOther,
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
      'getRefferedByOther',
    ]),

    firstName: {
      get () {
        return this.getFirstName
      },

      set (value) {
        this.debouncedProfileUpdate({ firstName: value })
      },
    },

    lastName: {
      get () {
        return this.getLastName
      },

      set (value) {
        this.debouncedProfileUpdate({ lastName: value })
      },
    },

    genderIdentity: {
      get () {
        return this.getGenderIdentity
      },

      set (value) {
        this.debouncedProfileUpdate({ genderIdentity: value })
      },
    },

    schoolCompanyName: {
      get () {
        return this.getSchoolCompanyName
      },

      set (value) {
        this.debouncedProfileUpdate({ schoolCompanyName: value })
      },
    },

    referredBy: {
      get () {
        return this.getReferredBy
      },

      set (value) {
        this.debouncedProfileUpdate({ referredBy: value })
      },
    },

    referredByOther: {
      get () {
        return this.getReferredByOther
      },

      set (value) {
        this.debouncedProfileUpdate({ referredByOther: value })
      },
    },
  },

  methods: mapActions(['updateBasicProfile']),
}
</script>