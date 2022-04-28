<template>
  <div>
    <EnergeticContainer heading="Overview">
      <div v-if="!submission.id" class="loading">
        <icon name="spinner" className="spin" />
        <div>Loading the submission... Happy Judging!</div>
      </div>
      <div v-else>
        <SubmissionOverview/>
      </div>
    </EnergeticContainer>
  </div>
</template>

<script>
import { mapState } from 'vuex'
import Icon from '../../../components/Icon'

import EnergeticContainer from "../../components/EnergeticContainer";
import SubmissionOverview from "../SubmissionOverview";
import JudgeRecusalPopup from '../JudgeRecusalPopup'

export default {
  computed: {
    ...mapState([
      'team',
      'score',
      'submission',
    ])
  },
  components: {
    Icon,
    EnergeticContainer,
    SubmissionOverview,
    JudgeRecusalPopup,
  },
}
</script>
