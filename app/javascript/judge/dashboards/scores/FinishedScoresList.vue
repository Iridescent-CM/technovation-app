<template>
  <div id="finished-scores">
    <div v-if="scores.length">
      <h2 class="text-base text-energetic-blue font-semibold tracking-wide uppercase">
        {{ this.title }}
      </h2>

      <div class="mt-2 flex flex-col">
        <div class="-my-2 -mx-4 overflow-x-auto sm:-mx-6 lg:-mx-8">
          <div class="inline-block min-w-full py-2 align-middle md:px-6 lg:px-8">
            <div class="overflow-hidden shadow ring-1 ring-black ring-opacity-5 md:rounded-lg">
              <table class="min-w-full divide-y divide-gray-300">
                <thead class="bg-gray-50">
                  <tr>
                    <th scope="col" class="py-3 pl-4 pr-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500 sm:pl-6">
                      Project Name
                    </th>
                    <th scope="col" class="px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500">
                      Team
                    </th>
                    <th scope="col" class="px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500">
                      Division
                    </th>
                    <th scope="col" class="px-3 py-3 text-left text-xs font-medium uppercase tracking-wide text-gray-500">
                      Score
                    </th>
                    <th scope="col" class="relative py-3 pl-3 pr-4 sm:pr-6">
                    </th>
                  </tr>
                </thead>

                <tbody class="divide-y divide-gray-200 bg-white">
                  <tr
                    v-for="score in scores"
                    :key="score.id">

                    <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6">
                      {{ score.submission_name }}
                    </td>
                    <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                      {{ score.team_name }}
                    </td>
                    <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                      <span class="division">{{ score.team_division }}</span>
                    </td>
                    <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                      {{ score.total }} / {{ score.total_possible }}
                    </td>
                    <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                      <a
                        v-if="scoresEditable"
                        :href="score.url"
                        class="link-button link-button-small link-button-success">
                        Review or Edit
                      </a>

                      <a
                        v-else
                        :href="`/judge/scores/${score.id}`"
                        class="link-button link-button-small link-button-neutral"
                        data-turbolinks="false">
                        View score
                      </a>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from 'vuex'

export default {
  computed: {
    ...mapGetters(['finishedQuarterfinalsScores', 'finishedSemifinalsScores']),

    scores () {
      switch (this.round) {
        case 'quarterfinals':
          return this.finishedQuarterfinalsScores
          break
        case 'semifinals':
          return this.finishedSemifinalsScores
          break
      }
    }
  },
  props: {
    title: {
      type: String,
      default: 'Finished Scores'
    },
    round: {
      type: String,
      default: 'quarterfinals',
      validator: (value) => ['quarterfinals', 'semifinals'].includes(value)
    },
    scoresEditable: {
      type: Boolean,
      default: true,
    }
  }
}
</script>

<style scoped>
.division {
  text-transform: capitalize;
}
</style>
