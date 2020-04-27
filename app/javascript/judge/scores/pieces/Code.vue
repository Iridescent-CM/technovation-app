<template>
  <div class="grid__col-6">
    <h4>Code</h4>

    <p>
      <a :href="submission.source_code_url" target="_blank" class="download-source-code">
        <icon name="code" color="ffffff" />
        <span>{{ submission.source_code_url_label }}</span>
      </a>
    </p>

    <p>Click <a href="https://www.technovationchallenge.org/judge-resources" target="_blank">here</a> for instructions to test source code</p>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import Icon from '../../../components/Icon'

export default {
  computed: mapState(['submission']),

  components: {
    Icon,
  },
}
</script>

<style scoped>
h4 {
  margin: 1rem 0 0;
}

a.download-source-code {
  display: flex;
}

img,
span {
  align-self: center;
  margin-right: 0.5rem;
}
</style>
