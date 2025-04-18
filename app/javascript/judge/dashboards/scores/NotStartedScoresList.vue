<template>
  <div class="mb-4">
    <div v-if="notStartedSubmissions.length">
      <p class="mb-4">
        Begin scoring your submissions. You will be able to edit
        your scores until the current round of judging closes.
        <span v-if="isLiveJudge">For more information about your
          events, please view your dashboard.
        </span>
      </p>

      <h2 class="text-base text-energetic-blue font-semibold tracking-wide uppercase">
        {{ this.title }}
      </h2>

      <div class="mt-2 mb-8 flex flex-col">
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
                    Judging Format
                  </th>
                  <th scope="col" class="relative py-3 pl-3 pr-4 sm:pr-6">
                  </th>
                </tr>
                </thead>

                <tbody class="divide-y divide-gray-200 bg-white">
                  <tr
                    v-for="submission in notStartedSubmissions"
                    :key="submission.id">
                    <td class="py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6">
                      {{ submission.app_name }}
                    </td>
                    <td class="px-3 py-4 text-sm text-gray-500">
                      {{ submission.team_name }}
                    </td>
                    <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500 capitalize">
                      <span class="division">{{ submission.team_division }}</span>
                    </td>
                    <td class="whitespace-nowrap px-3 py-4 text-sm text-gray-500">
                      {{ submission.judging_format }}
                    </td>
                    <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6">
                      <a
                        v-if="scoresEditable"
                        :href="newScoreUrl(submission)"
                        class="link-button link-button-small link-button-success">
                        Start
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
    <div v-else>
      <p v-if="isLiveJudge">
        You currently do not have any new submissions to score.
        Please contact your chapter ambassador if this is a mistake.
      </p>
      <p v-else>
        To start a new score, complete any scores in progress.
      </p>
    </div>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'

export default {
  computed: {
    ...mapGetters(['notStartedSubmissions']),
  },

  props: {
    title: {
      type: String,
      default: 'Submissions to Score'
    },
    scoresEditable: {
      type: Boolean,
      default: true,
    },
    isLiveJudge: {
      type: Boolean,
      default: false,
    },
  },

  methods: {
    newScoreUrl(submission) {
      if (submission.score_id) {
        return `/judge/scores/new?score_id=${submission.score_id}`
      } else if (submission.submission_id) {
        return `/judge/scores/new?team_submission_id=${submission.submission_id}`
      }
    }
  }
}
</script>
