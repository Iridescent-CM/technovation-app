<template>
  <dl>
    <dt>Team</dt>
    <dd>{{ team.name }}</dd>

    <dt>Submission</dt>
    <dd>{{ submission.name }}</dd>
  </dl>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState([
    'team',
    'submission',
  ]),
}
</script>
