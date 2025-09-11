<template>
  <form class="simple_form" @submit.prevent="handleSubmit">
    <div v-if="isAdmin" class="panel__top-bar">
      Confirm {{ subjectPossessive }} region
    </div>

    <div id="location-change" class="tw-blue-lg-container">
      <div
        v-if="!isAdmin"
        class="sm-header-wrapper bg-energetic-blue text-white p-2"
      >
        <p class="font-bold">Confirm {{ subjectPossessive }} region</p>
      </div>

      <div v-if="isNotFound" class="flash flash--error">
        We're sorry, but we cannot find a region with that information.
      </div>

      <div v-if="suggestions.length" class="flash">
        We couldn't match exact results to the information that you gave us.<br />
        If the location you entered returns several options, please click the
        one of the lines for the option that best matches your location.
      </div>

      <div class="p-6">
        <template v-if="savedLocation">
          <p class="padding--t-r-l-none margin--t-r-l-none margin--b-large">
            We have saved {{ subjectPossessive }} region as:
          </p>

          <div ref="savedLocationTable">
            <div class="Rtable Rtable--3cols">
              <div class="Rtable-cell padding--t-b-none padding--r-l-large">
                <h6 class="margin--none">City</h6>
              </div>

              <div class="Rtable-cell padding--t-b-none padding--r-l-large">
                <h6 class="margin--none">State / Province</h6>
              </div>

              <div class="Rtable-cell padding--t-b-none padding--r-l-large">
                <h6 class="margin--none">Country / Territory</h6>
              </div>
            </div>

            <div class="Rtable Rtable--3cols" ref="savedLocationTableRow">
              <div class="Rtable-cell padding--t-b-medium padding--r-l-large">
                {{ savedLocation.city || "(no city)" }}
              </div>

              <div class="Rtable-cell padding--t-b-medium padding--r-l-large">
                {{ savedLocation.state || "(no state/province)" }}
              </div>

              <div class="Rtable-cell padding--t-b-medium padding--r-l-large">
                {{ savedLocation.country || "(no country)" }}
              </div>
            </div>
          </div>
        </template>

        <template v-if="suggestions.length">
          <div ref="suggestionsTable">
            <div class="Rtable Rtable--3cols">
              <div class="Rtable-cell padding--t-b-none"><h6>City</h6></div>
              <div class="Rtable-cell padding--t-b-none">
                <h6>State / Province</h6>
              </div>
              <div class="Rtable-cell padding--t-b-none">
                <h6>Country / Territory</h6>
              </div>
            </div>

            <div
              class="Rtable Rtable--3cols suggestion"
              v-for="suggestion in suggestions"
              :key="suggestion.id"
              @click="handleSuggestionClick(suggestion)"
            >
              <div class="Rtable-cell padding--t-b-medium padding--r-l-large">
                {{ suggestion.city || "(no city)" }}
              </div>

              <div class="Rtable-cell padding--t-b-medium padding--r-l-large">
                {{ suggestion.state || "(no state/province)" }}
              </div>

              <div class="Rtable-cell padding--t-b-medium padding--r-l-large">
                {{ suggestion.country || "(no country)" }}
              </div>
            </div>
          </div>
        </template>

        <div v-show="!savedLocation">
          <template v-if="countryConfirmed || country !== 'Israel'">
            <label for="location_country">Country / Territory</label>

            <input
              ref="countryField"
              type="text"
              id="location_country"
              autocomplete="country-name"
              v-model="country"
            />
          </template>

          <template v-else>
            <label>Please choose the correct territory:</label>

            <p class="inline-checkbox">
              <label>
                <input
                  type="radio"
                  name="location_country"
                  value="Israel"
                  v-model="country"
                  @click="confirmCountry('Israel')"
                />
                Israel
              </label>
            </p>

            <p class="inline-checkbox">
              <label>
                <input
                  type="radio"
                  name="location_country"
                  value="Palestine"
                  v-model="country"
                  @click="confirmCountry('Palestine')"
                />
                Palestine
              </label>
            </p>
          </template>

          <label for="location_state"
            >State / Province {{ optionalStateLabel }}</label
          >

          <input
            type="text"
            id="location_state"
            autocomplete="address-level1"
            :placeholder="optionalStatePlaceholder"
            v-model="state"
          />

          <label for="location_city">City</label>

          <input
            type="text"
            id="location_city"
            ref="cityField"
            autocomplete="address-level2"
            v-model="city"
          />

          <a
            href="#"
            class="color--danger font-size--small padding--t-b-medium"
            @click.prevent="resetAll"
            v-if="formHasInput"
          >
            reset this form
          </a>
        </div>

        <a
          class="button float--left"
          @click.prevent="handleBack"
          v-if="showBackBtn"
        >
          Back
        </a>
        <p class="padding--none margin--none">
          <a
            href="#"
            class="tw-green-btn float--left"
            v-if="showCancel"
            @click.prevent="handleCancel"
          >
            {{ cancelText }}
          </a>
          &nbsp;
          <button
            class="tw-green-btn float--right"
            :disabled="searching"
            @click.prevent="handleSubmit"
          >
            {{ submitText }}
          </button>
        </p>
      </div>
    </div>
  </form>
</template>

<script>
import LocationResult from "../models/LocationResult";
import HttpStatusCodes from "../../constants/HttpStatusCodes";
import Swal from "sweetalert2";

export default {
  data() {
    return {
      city: "",
      state: "",
      country: "",
      countryConfirmed: null,
      suggestions: [],
      savedLocation: null,
      searching: false,
      status: null,
    };
  },

  props: {
    wizardToken: {
      type: String,
      required: false,
      default: "",
    },

    accountId: {
      type: [Number, Boolean],
      required: false,
      default: false,
    },

    teamId: {
      type: [Number, Boolean],
      required: false,
      default: false,
    },

    chapterId: {
      type: [Number, Boolean],
      required: false,
      default: false,
    },

    clubId: {
      type: [Number, Boolean],
      required: false,
      default: false,
    },

    scopeName: {
      type: String,
      required: true,
    },

    value: {
      type: Object,
      required: false,
      default: null,
    },

    handleBack: {
      type: Function,
      required: false,
      default: () => history.back(),
    },

    showBackBtn: {
      type: Boolean,
      required: false,
      default: false,
    },

    handleConfirm: {
      type: Function,
      required: false,
      default: () => history.back(),
    },

    showFinalCancel: {
      type: Boolean,
      required: false,
      default: true,
    },
  },

  created() {
    if (this.value) {
      this.city = this.value.city;
      this.state = this.value.state;
      this.country = this.value.country;
    } else {
      window.axios.get(this.getCurrentLocationEndpoint).then(({ data }) => {
        this.city = data.city;
        this.state = data.state;
        this.country = data.country;
      });
    }
  },

  mounted() {
    if (
      window.location.pathname === "/chapter_ambassador/chapter_location/edit"
    ) {
      this.openAlertMessage({ chapterableType: "chapter" });
    } else if (
      window.location.pathname === "/club_ambassador/club_location/edit"
    ) {
      this.openAlertMessage({ chapterableType: "club" });
    }
  },

  computed: {
    countryDetectedInStateOptionalList() {
      if (!this.country || !this.country.length) return false;

      return (
        this.country.match(/^\s*(hong\s*kong|hk)\s*$/i) ||
        this.country.match(/^\s*(palestine|ps)\s*/i) ||
        this.country.match(/^\s*(india|ind?)\s*$/i) ||
        this.country.match(/^\s*(taiwan,?.*|tw)\s*$/i)
      );
    },

    optionalStateLabel() {
      if (this.countryDetectedInStateOptionalList) return "(Optional)";

      return "";
    },

    optionalStatePlaceholder() {
      if (this.countryDetectedInStateOptionalList)
        return "In your area, it's okay if this field is blank.";

      return "";
    },

    cancelText() {
      if (this.savedLocation) {
        return "change region";
      } else {
        return "cancel";
      }
    },

    submitText() {
      if (this.savedLocation) {
        return "Confirm";
      } else {
        return "Next";
      }
    },

    subjectPossessive() {
      if (this.accountId) {
        return "this person's";
      } else if (this.teamId) {
        return "this team's";
      } else if (this.chapterId) {
        return "this chapter's";
      } else if (this.clubId) {
        return "this club's";
      } else {
        return "your";
      }
    },

    isNotFound() {
      return this.status === HttpStatusCodes.NOT_FOUND;
    },

    formHasInput() {
      return (
        (this.city && this.city.length) ||
        (this.state && this.state.length) ||
        (this.country && this.country.length)
      );
    },

    isStudent() {
      return this.scopeName === "student";
    },

    isJudge() {
      return this.scopeName === "judge";
    },

    isChA() {
      return this.scopeName === "chapter_ambassador";
    },

    isAdmin() {
      return this.scopeName === "admin";
    },

    getCurrentLocationEndpoint() {
      return this._getEndpoint("current_location");
    },

    patchLocationEndpoint() {
      return this._getEndpoint("location");
    },

    params() {
      const rootParamName = `${this.scopeName}_location`;
      let params = {};

      params[rootParamName] = {
        city: this.city,
        state: this.state,
        country: this.country,
        token: this.wizardToken,
      };

      return params;
    },

    showCancel() {
      return this.showFinalCancel || this.savedLocation;
    },
  },

  watch: {
    status(newStatus) {
      switch (newStatus) {
        case HttpStatusCodes.NOT_FOUND:
          console.warn("geocoding results not found");
          this.$refs.countryField.focus();
        default:
        // no op
      }
    },

    city(value) {
      this.$emit(
        "input",
        Object.assign(
          {},
          {
            city: value,
            state: this.state,
            country: this.country,
          }
        )
      );
    },

    state(value) {
      this.$emit(
        "input",
        Object.assign(
          {},
          {
            city: this.city,
            state: value,
            country: this.country,
          }
        )
      );
    },

    country(value) {
      this.$emit(
        "input",
        Object.assign(
          {},
          {
            city: this.city,
            state: this.state,
            country: value,
          }
        )
      );
    },
  },

  methods: {
    handleSubmit() {
      if (this.savedLocation) {
        this.saveLocation();
      } else if (!this.formHasInput) {
        this.handleErrorResponse({ response: { status: 404 } });
      } else {
        this.resetMeta();
        this.searching = true;

        window.axios
          .patch(this.patchLocationEndpoint, this.params)
          .then(({ status, data }) => {
            this.handleOKResponse(status, data);
          })
          .catch((err) => {
            this.handleErrorResponse(err);
          });
      }
    },

    saveLocation() {
      window.axios
        .post(this.patchLocationEndpoint, this.params)
        .then(() => {
          this.handleConfirm();
        })
        .catch((err) => {
          console.error(err);
        });
    },

    handleCancel() {
      if (this.savedLocation) {
        this.resetMeta();
        this.$nextTick(() => {
          this.$refs.countryField.focus();
        });
      } else {
        // for when we do showFinalCancel
        history.back();
      }
    },

    handleSuggestionClick(suggestion) {
      this.searching = true;
      this.city = suggestion.city;
      this.state = suggestion.state;
      this.confirmCountry(suggestion.country);
      this.saveLocation();
    },

    handleOKResponse(status, data) {
      this.searching = false;
      this.status = status;
      this.savedLocation = new LocationResult(data.results[0]);
      this.city = this.savedLocation.city;
      this.state = this.savedLocation.state;
      this.confirmCountry(this.savedLocation.country);
    },

    handleErrorResponse(err) {
      this.searching = false;
      this.status = err.response.status;

      if (this.status === HttpStatusCodes.MULTIPLE_CHOICES) {
        this.suggestions = err.response.data.results.map((result) => {
          return new LocationResult(result);
        });

        const countrySensitivityList = ["Israel", "Palestine, State of"];

        const countries = this.suggestions.map((l) => l.country);
        const matched = countries.filter((c) => c === this.country)[0];

        if (
          this.countryConfirmed &&
          matched &&
          matched.length &&
          countries.length === countrySensitivityList.length &&
          countries
            .sort()
            .every(
              (value, index) => value === countrySensitivityList.sort()[index]
            )
        ) {
          const result = {
            id: Math.floor(Math.random() * 16777215).toString(16),
            city: this.city,
            state: this.state,
            country: matched,
          };

          this.suggestions = [];
          this.handleOKResponse(200, { results: [result] });
        }
      }
    },

    confirmCountry(country) {
      this.country = country;
      this.countryConfirmed = true;
    },

    resetAll() {
      this.resetForm();
      this.resetMeta();

      this.$nextTick(() => {
        this.$refs.countryField.focus();
      });
    },

    resetForm() {
      this.city = "";
      this.state = "";
      this.country = "";
    },

    resetMeta() {
      this.suggestions = [];
      this.savedLocation = null;
      this.status = null;
      this.searching = false;
    },

    _getEndpoint(pathPart) {
      let endpointRoot;

      if (this.scopeName === "chapter_ambassador" && this.chapterId) {
        endpointRoot = `/chapter_ambassador/chapter_${pathPart}`;
      } else if (this.scopeName === "club_ambassador" && this.clubId) {
        endpointRoot = `/club_ambassador/club_${pathPart}`;
      } else {
        endpointRoot = `/${this.scopeName}/${pathPart}`;
      }

      if (this.accountId) {
        return `${endpointRoot}?account_id=${this.accountId}`;
      } else if (this.teamId) {
        return `${endpointRoot}?team_id=${this.teamId}`;
      } else if (this.chapterId) {
        return `${endpointRoot}?chapter_id=${this.chapterId}`;
      } else if (this.clubId) {
        return `${endpointRoot}?club_id=${this.clubId}`;
      } else {
        return endpointRoot;
      }
    },

    openAlertMessage({ chapterableType }) {
      Swal.fire({
        html: `
          <p>
          The ${chapterableType} location determines which users see your ${chapterableType} as a suggested ${chapterableType} when they register.
          Students and mentors see a list of ${chapterableType}s in their local area or their country.
          </p>

          <p class="mt-8">By editing your location, you understand that it may change which users can join your ${chapterableType} when they register.</p>

          <p class="mt-8">Please contact <a href=mailto:"${process.env.HELP_EMAIL}" class="tw-link">${process.env.HELP_EMAIL}</a> with any questions.</p>
          `,
        confirmButtonText: "OK",
        confirmButtonColor: "#3FA428",
        width: "50%",
      });
    },
  },
};
</script>

<style lang="scss" scoped>
label:not(:first-child) {
  @apply mt-8;
}

.Rtable {
  @apply flex flex-wrap m-0 p-0;
}

.suggestion {
  @apply transition-colors duration-200 hover:bg-sky-200;
}

.Rtable-cell {
  @apply cursor-pointer flex-grow w-full overflow-hidden w-1/3;
}
</style>
