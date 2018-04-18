<template>
  <div class="grid__col-6">
    <h4>Code</h4>

    <p>
      <a :href="submission.source_code_url" target="_blank">
        <icon name="code" color="ffffff" />
        <span>Download the source code</span>
      </a>
    </p>

    <h4>Code Checklist</h4>

    <p>
      {{ team.name }} automatically earned

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
import Icon from '../../../components/Icon'

export default {
  computed: mapState(['team', 'submission']),

  components: {
    Icon,
  },
}
</script>

<style scoped>
h4 {
  margin: 1rem 0 0;
}

a {
  display: flex;
}

img,
span {
  align-self: center;
  margin-right: 0.5rem;
}
</style>
