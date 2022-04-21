<template>
  <div>
    <EnergeticContainer heading="Review Submission">
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

import TeamInfo from '../TeamInfo'
import Screenshots from '../pieces/Screenshots'
import TcCode from '../pieces/Code'
import Business from '../pieces/Business'
import Presentation from '../pieces/Presentation'
import JudgeRecusalPopup from '../JudgeRecusalPopup'
import EnergeticContainer from "../../components/EnergeticContainer";
import SubmissionOverview from "../SubmissionOverview";

export default {
  computed: {
    ...mapState([
      'team',
      'score',
      'submission',
    ])
  },
  components: {
    SubmissionOverview,
    EnergeticContainer,
    Icon,
    TeamInfo,
    Screenshots,
    TcCode,
    Business,
    Presentation,
    JudgeRecusalPopup,
  },
}
</script>