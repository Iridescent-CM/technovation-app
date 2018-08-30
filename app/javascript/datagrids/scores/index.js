import Vue from 'vue'

document.addEventListener('turbolinks:load', () => {
  const table = document.querySelector("table.scored_submissions_grid")

  if (table != undefined) {
    new Vue({
      el: table,

      methods: {
        updateContestRank (evt) {
          const submissionId = evt.target.dataset.submissionId
          const value = evt.target.value

          let form = new FormData()
          form.append("team_submission[id]", submissionId)
          form.append("team_submission[contest_rank]", value)

          $.ajax({
            url: "/admin/contest_rank_changes",
            method: "POST",
            data: form,
            contentType: false,
            processData: false,
            success (resp) {
              $("#flash").text(resp.msg)
            },
          })
        },
      },
    });
  }
})
