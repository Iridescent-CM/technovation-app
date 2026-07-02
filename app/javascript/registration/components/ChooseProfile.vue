<template>
  <form class="panel panel--contains-bottom-bar panel--contains-top-bar">
    <div class="panel__top-bar">Choose your profile type</div>

    <div v-if="profileOptions.length" class="panel__content">
      <div v-if="!isLocked" class="grid grid--justify-space-around">
        <div class="grid__col-12">Due to your age, you can be a:</div>

        <div
          v-for="option in profileOptions"
          :key="option"
          :class="['opacity--50', 'hover--opacity-75', getCSSForOption(option)]"
        >
          <label class="text-align--center">
            <img :src="getProfileIconSrc(option)" />

            <input
              v-model="profileChoice"
              type="radio"
              name="profileChoice"
              :value="option"
            />
            {{ option }}
          </label>
        </div>
      </div>

      <div v-else class="text-align--center">
        <img :src="getProfileIconSrc(profileChoice)" width="300" />
        <br />You are a {{ profileChoice }}
      </div>
    </div>

    <div v-else-if="!profileOptions.length" class="panel__content">
      <div class="grid grid--justify-space-around">
        <div class="grid__col-12">
          <p>You must be at least 10 years old by World Summit to sign up.</p>
          <p>
            Although you cannot take part in our competition, you can use our
            <a
              href="https://technovationchallenge.org/curriculum-intro/registered/new/"
              >curriculum</a
            >
            to work on a project on your own.
          </p>
        </div>
      </div>
    </div>

    <div class="panel__bottom-bar">
      <a class="button float--left" @click.prevent="navigateBack"> Back </a>
      <br clear="all" />
    </div>
  </form>
</template>

<script>
import { createNamespacedHelpers } from "vuex";

const { mapState, mapGetters, mapActions } =
  createNamespacedHelpers("registration");

export default {
  beforeRouteEnter(_to, from, next) {
    next((vm) => {
      if (vm.isAgeSet) {
        next();
      } else {
        vm.$router.replace(from.path);
      }
    });
  },
  props: {
    profileIcons: {
      type: Object,
      default() {
        return {
          profileIconMentor: "",
          profileIconMentorMale: "",
          profileIconStudent: "",
        };
      },
    },
  },

  computed: {
    ...mapState(["months", "birthMonth", "genderIdentity", "isLocked"]),

    ...mapGetters(["getAge", "getAgeByCutoff", "isAgeSet", "getBirthdate"]),

    profileChoice: {
      get() {
        return this.$store.state.registration.profileChoice;
      },

      set(choice) {
        this.$store.commit("registration/profileChoice", choice);
      },
    },

    profileOptions() {
      /* eslint-disable vue/no-side-effects-in-computed-properties */
      if (this.getAgeByCutoff < 10) {
        this.profileChoice = null;
        return [];
      }

      if (this.getAge() < 18) {
        this.profileChoice = "student";
        return ["student"];
      }

      if (this.getAgeByCutoff > 18) {
        this.profileChoice = "mentor";
        return ["mentor"];
      }

      if (this.getAge() == 18 && this.getAgeByCutoff < 19) {
        return ["mentor", "student"];
      }

      this.profileChoice = null;
      return [];
      /* eslint-enable vue/no-side-effects-in-computed-properties */
    },
  },

  watch: {
    profileChoice(value) {
      this.updateProfileChoice(value);
    },

    profileOptions(arr) {
      if (arr.length === 1) this.profileChoice = arr[0];
    },
  },

  methods: {
    ...mapActions(["updateProfileChoice"]),

    navigateBack() {
      this.$router.push({ name: "age" });
    },

    getProfileIconSrc(choice) {
      if (choice) {
        const capitalizedChoice =
          choice.charAt(0).toUpperCase() + choice.slice(1);

        if (
          choice === "mentor" &&
          this.$store.state.registration.genderIdentity === "Male"
        ) {
          return this.profileIcons.profileIconMentorMale;
        } else {
          return this.profileIcons[`profileIcon${capitalizedChoice}`];
        }
      } else {
        return "";
      }
    },

    getCSSForOption(option) {
      if (this.profileOptions.length === 1) return "opacity--100 grid__col-6";

      if (this.profileChoice === option) return "opacity--100 grid__col-auto";

      return "grid__col-auto";
    },
  },
};
</script>

<style lang="scss" scoped>
label:not(:first-child) {
  margin: 2rem 0 0;
}
</style>
