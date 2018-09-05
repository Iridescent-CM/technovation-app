<template>
  <div class="grid__cell">
    <h1 class="page-heading">
      <slot name="title"></slot>
      <slot name="survey-links"></slot>
      <small>
        <drop-down label="More Information">
          <h6>
            Submission Guide
            <small>
              <a
                href="https://www.technovationchallenge.org/submission-guidelines/"
                target="_blank"
              >Read the Submission Guidelines</a>
            </small>
          </h6>
          <h6>
            Judging Rubric
            <small>
              <a
                href="https://www.technovationchallenge.org/judging-rubric/"
                target="_blank"
              >Read the Judging Rubric</a>
            </small>
          </h6>
          <slot name="content"></slot>
        </drop-down>
      </small>
    </h1>
  </div>
</template>

<script>
import DropDown from 'components/DropDown'
import Icon from 'components/Icon'

export default {
  name: 'top-section-header',

  components: {
    DropDown,
    Icon,
  },
}
</script>
