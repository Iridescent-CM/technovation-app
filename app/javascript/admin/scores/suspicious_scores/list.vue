<template>
  <div class="suspicious-scores">
    <h1>Suspicious Scores</h1>

    <div class="score score--header">
      <div>Judge</div>
      <div>Submission</div>
      <div>Team</div>
      <div>Event</div>
      <div>Score</div>
      <div>Flags</div>
    </div>

    <div v-if="scores.length === 0">
      There are no suspicious scores at this time.
    </div>

    <div
      class="score"
      v-for="score in scores"
    >
      <div class="score__judge-name">
        <a :href="score.judge_url">{{ score.judge_name }}</a>
      </div>

      <div class="score__submission-name">
        <a :href="score.submission_url">{{ score.submission_name }}</a>
      </div>

      <div class="score__team-name">
        {{ score.team_name }}
        <small>{{ score.team_division }} division</small>
      </div>

      <div class="score__event-name">
        {{ score.event_name }}
        <small>{{ score.event_official }}</small>
      </div>

      <div class="score__total">
        {{ score.raw_total }} / {{ score.total_possible }}
      </div>

      <div class="score__flags">
        <small>{{ score.flags }}</small>
        <a :href="score.url">Open score</a>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState(['scores']),
}
</script>

<style lang="scss" scoped>
.score {
  display: flex;
  justify-content: space-between;
  margin: 0 0 1rem;

  div {
    width: 20%;

    small {
      display: block;
      color: #777;
      text-transform: uppercase;
      font-weight: bold;
      font-size: 0.9rem;
    }
  }
}

.score--header {
  font-weight: bold;
}

h1 {
  font-size: 1.4rem;
  text-align: left;
  margin: 0 0 1rem;
}
</style>
