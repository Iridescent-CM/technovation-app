<template>
  <div class="grid__col-6">
    <h4>Code</h4>

    <a :href="submission.source_code_url" target="_blank">
      Download the source code
    </a>

    <p>
      {{ team.name }} earned

      <strong>
        {{ submission.total_checklist_points }}
        {{ submission.total_checklist_points | pluralize('point') }}
      </strong>

      for their code checklist.
    </p>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState(['team', 'submission']),
}
</script>
