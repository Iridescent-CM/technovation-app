<template>
  <div v-if="!questions.length" class="loading">
    <icon name="spinner" className="spin" />
    <div>Loading questions...</div>
  </div>

  <ol v-else>
    <li class="score-question" v-for="question in questions">
      <span v-html="question.text"></span>

      <div v-if="question.text.trim() == 'Do we explain what we learned about AI and how we used it in our project?'" class="border-l-2 border-energetic-blue bg-blue-50 p-2 my-4">
        <div class="help-text text-base font-normal">
          <h4 class="mb-4 text-xl">Judging Guidance</h4>
          <p>
            Please keep the following in mind for this question:
          </p>

          <h5 class="mt-4 text-normal">If the team does not mention AI at all</h5>
          <p class="my-2">
            Award a 1.
          </p>

          <h5 class="mt-4 text-normal">If the team did not use AI</h5>
          <p class="my-2">
            A simple mention of not using AI without any reason why should be a 3.
            If they talk about not using AI and why they chose not to, that is a 4
            or 5, dependent on detail.
          </p>

          <h5 class="mt-4 text-normal">If the team did use AI</h5>
          <p class="my-2">
            A simple mention of using AI without reason why or details should be a
            3. If they talk about how they used AI and why it was useful, award a 4
            or 5, dependent on detail.
          </p>
        </div>
      </div>

      <ol>
        <li
          v-for="n in question.worth"
          :class="['score-value', question.score === n ? 'selected' : '']"
          @click="updateScores(question, n)"
          v-tooltip.top-center="explainScore(n)"
        >
          {{ n }}
        </li>
      </ol>
    </li>

    <slot />
  </ol>
</template>

<script>
import Icon from "../../components/Icon";
import { mapState } from "vuex";

export default {
  computed: mapState(["team"]),

  components: {
    Icon,
  },

  props: ["questions"],

  methods: {
    updateScores(question, score) {
      this.$store.commit("updateScores", {
        section: question.section,
        idx: question.idx,
        score: score,
      });
    },

    explainScore(score) {
      switch (score) {
        case 1:
          return "Not there/Missing";
        case 2:
          return "Getting there (below expectations)";
        case 3:
          return "Average (meets basic expectations)";
        case 4:
          return "Good";
        case 5:
          return "Amazing";
      }
    },
  },
};
</script>

<style lang="scss" scoped>
ol {
  list-style: none;
  margin: 0 auto;
  padding: 0 0 2rem;
  width: 40vw;

  ol {
    margin: 1rem 0 0;
    padding: 0;
    display: flex;
    justify-content: space-between;
  }
}

.score-question {
  margin: 3rem 0 0;
  padding: 0;
  font-weight: bold;
  font-size: 1.2rem;
}

.score-value {
  opacity: 0.5;
  background: none;
  border: 1px solid #43b02a;
  padding: 1.2rem 1.7rem;
  border-radius: 50%;
  font-weight: bold;
  color: #43b02a;
  transition: opacity 0.2s;
  cursor: pointer;

  &:hover {
    opacity: 0.3;
    background: #43b02a;
    color: white;
  }

  &.selected,
  &.selected:hover {
    opacity: 1;
    background: #43b02a;
    color: white;
  }
}

.loading {
  padding: 2rem;
  text-align: center;

  div {
    margin: 1rem auto;
  }
}
</style>
