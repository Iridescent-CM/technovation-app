<template>
  <div class="mt-6">
    <p>
      <a
        v-if="submission.source_code_url"
        :href="submission.source_code_url"
        target="_blank"
        class="text-energetic-blue text-lg flex"
        @click="trackSourceCodeDownload"
      >
        <app-icon name="code" color="0075cf" />
        <span class="self-center"
          >{{ submission.source_code_url_label }} (optional)</span
        >
      </a>

      <a
        v-if="submission.download_source_code_url"
        :href="submission.download_source_code_url"
        target="_blank"
        class="text-energetic-blue text-lg flex"
        @click="trackSourceCodeDownload"
      >
        <app-icon name="code" color="0075cf" />
        <span class="self-center"
          >Download the source code for this project (optional)</span
        >
      </a>
    </p>
  </div>
</template>

<script>
import { mapState } from "vuex";
import AppIcon from "../../../components/AppIcon";

export default {
  name: "SourceCode",
  components: {
    AppIcon,
  },

  computed: mapState(["score", "submission"]),

  methods: {
    async trackSourceCodeDownload() {
      await window.axios.patch(`/judge/scores/${this.score.id}`, {
        submission_score: { downloaded_source_code: true },
      });
    },
  },
};
</script>
