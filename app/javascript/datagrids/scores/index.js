import Vue from 'vue/dist/vue.esm'

document.addEventListener('turbolinks:load', () => {
  const table = document.querySelector("table.scored_submissions_grid")

  if (table != undefined) {
    new Vue({
      el: table,
      mounted () {
        console.log(this.$el)
      },
    });
  }
})
