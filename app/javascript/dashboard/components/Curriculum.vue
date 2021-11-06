<template>
  <div :class="mainVerticalTabsClass">
    <div :class="tabClass">
      <div :class="gridClass">
        <div :class="gridTwelveClass">
          <div id="curriculum" class="h-auto mb-auto rounded-md border-solid border-4 border-energetic-blue">
            <div class="sm-header-wrapper ">
              <p class="font-bold">Curriculum</p>
            </div>

            <div class="tw-content=-wrapper p-8">

              <section>
                <p>Learn how to make your project as strong as possible by following these lessons. Most participants
                  spend around 60 hours working on their ideas.</p>

                <p class="mt-6">
                  <a href="https://technovationchallenge.org/curriculum-intro/registered/new/" class="tw-green-btn"
                     target="_blank">
                    Go to Lessons
                  </a>
                </p>
              </section>

              <section class="mt-12">
                <p class="font-bold">Visit these helpful links to prepare your app for judging:</p>

                <ul>
                  <li>
                    <a href="https://technovationchallenge.org/submission-guidelines/" target="_blank" class="tw-link">
                      Submission Guidelines (updated each season)
                    </a>
                  </li>

                  <li>
                    <a href="https://technovationchallenge.org/curriculum/judging-rubric/" target="_blank" class="tw-link">
                      Judging Rubric
                    </a>
                  </li>

                  <li>
                    <a href="https://technovationchallenge.org/wp-content/uploads/2020/09/Technovation-Girls-2021-Season-Timeline-Key-Dates-Infographic.pdf"
                       target="_blank" class="tw-link">
                      Suggested Milestones
                    </a>
                  </li>

                  <li>
                    <a href="https://technovationchallenge.org/award-structure/" target="_blank" class="tw-link">
                      Awards Page
                    </a>
                  </li>

                  <li>
                    <a href="https://www.technovation.org/app-gallery/" target="_blank" class="tw-link">
                      Apps from Past Teams
                    </a>
                  </li>
                </ul>





              </section>

            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'curriculum',

  data() {
    return {
      isStudentDash: false
    }
  },

  beforeMount() {
    let pathname = window.location.pathname
    if (pathname === '/student/dashboard') {
      this.isStudentDash = true
    }
  },

  computed: {
    mainVerticalTabsClass() {
      if (!this.isStudentDash) {
        return 'tabs tabs--vertical tabs--css-only grid'
      }
    },

    gridClass() {
      if (!this.isStudentDash) {
        return 'grid'
      }
    },

    gridTwelveClass() {
      if (!this.isStudentDash) {
        return 'grid__col-12'
      }
    },

    tabClass() {
      if (!this.isStudentDash) {
        return 'tabs__content grid__col-12 tabs__content--embedd'
      }
    }
  }
}
</script>
