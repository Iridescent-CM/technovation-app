import { digStateAttributes } from "utilities/vuex-utils";

export default {
  currentAccountName(state) {
    return digStateAttributes(state, "currentAccount", "name");
  },

  currentAccountAvatarUrl(state) {
    return digStateAttributes(state, "currentAccount", "avatarUrl");
  },

  chapterAmbassadorName(state) {
    return digStateAttributes(state, "chapterAmbassador", "name");
  },

  assignedToChapter(state) {
    return digStateAttributes(state, "currentAccount", "assignedToChapter");
  },

  chapterName(state) {
    return digStateAttributes(state, "currentAccount", "chapterName");
  },

  chapterAmbassadorAvatarUrl(state) {
    return digStateAttributes(state, "chapterAmbassador", "avatarUrl");
  },

  chapterAmbassadorHasProvidedIntro(state) {
    return digStateAttributes(state, "chapterAmbassador", "hasProvidedIntro");
  },

  canJoinTeams(state) {
    return digStateAttributes(state, "currentMentor", "isOnboarded");
  },

  isOnboarded(state) {
    return digStateAttributes(state, "currentMentor", "isOnboarded");
  },

  nextOnboardingStep(state) {
    return digStateAttributes(state, "currentMentor", "nextOnboardingStep");
  },

  isTrainingComplete(state) {
    return digStateAttributes(state, "currentMentor", "isTrainingComplete");
  },

  isBioFilled(state) {
    return digStateAttributes(
      state,
      "currentMentor",
      "bio",
      (bio) => bio.length
    );
  },

  isConsentSigned(state) {
    return digStateAttributes(state, "consentWaiver", "isSigned");
  },

  isBackgroundCheckClear(state) {
    return digStateAttributes(state, "backgroundCheck", "isClear");
  },

  isBackgroundCheckWaived(state) {
    const backgroundCheckCountryCodes =
      state.settings.backgroundCheckCountryCodes;

    const isBackgroundCheckCountry = digStateAttributes(
      state,
      "currentAccount",
      "countryCode",
      (code) => backgroundCheckCountryCodes.includes(code)
    );

    const isAgeAppropriate = digStateAttributes(
      state,
      "currentAccount",
      "age",
      (age) => parseInt(age) >= 18
    );

    const isExempt = digStateAttributes(
      state,
      "currentAccount",
      "backgroundCheckExemption"
    );

    return !isBackgroundCheckCountry || !isAgeAppropriate || isExempt;
  },

  isOnTeam(state) {
    return state.currentTeams.length;
  },

  backgroundCheckUpdatedAtEpoch(state) {
    return digStateAttributes(state, "backgroundCheck", "updatedAtEpoch");
  },

  consentWaiverSignedAtEpoch(state) {
    return digStateAttributes(state, "consentWaiver", "signedAtEpoch");
  },

  canDisplayScores(state) {
    return state.settings.canDisplayScores;
  },
};
