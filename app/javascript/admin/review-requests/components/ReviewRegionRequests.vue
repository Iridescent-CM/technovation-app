<template>
  <div class="admin-requests-list">
    <template v-for="request in requests">
      <div :key="request.id" class="grid-list">
        <div class="grid-list__col-1">
          <img :src="request.requestor_avatar" width="100" />
        </div>

        <div class="grid-list__col-4">
          <h1>{{ request.requestor_name }}</h1>

          <h2>{{ request.requestor_meta.primary_region }}</h2>

          <ul class="list--reset">
            <li
              :key="region"
              v-for="region in request.requestor_meta.other_regions"
            >
              {{ region }}
            </li>
          </ul>
        </div>

        <div class="grid-list__col-4">
          <h3>{{ listTitle }}</h3>

          <ul class="list--reset">
            <li
              :key="region"
              v-for="region in request.requestor_meta.requesting_regions"
            >
              {{ region }}
            </li>
          </ul>
        </div>

        <div class="grid-list__col-2">
          <button @click="reviewRequest(request)">{{ actionBtnTxt }}</button>
        </div>
      </div>
    </template>

    <div class="padding--medium color--light weight--bold align--center">
      No more {{ requestStatus }} requests
    </div>
  </div>
</template>

<script>
import swal from 'sweetalert2'

export default {
  props: ['requests', 'requestStatus', 'actionBtnTxt', 'listTitle'],

  methods: {
    reviewRequest(request) {
      swal({
        title: request.requestor_name,
        html: this.buildReviewHTML(request),
        confirmButtonText: 'Approve',
        showCancelButton: true,
        cancelButtonText: 'Decline',
        reverseButtons: true,
        showLoaderOnConfirm: true,
        showCloseButton: true,
      }).then((result) => {
        if (result.value) {
          this.approveRequest(request)
        } else if (result.dismiss === swal.DismissReason.cancel) {
          this.declineRequest(request)
        }
      })
    },

    approveRequest(request) {
      this.updateRequest(
        request,
        {
          attributes: { request_status: "approved" },
          verify: "isApproved",
        }
      )
    },

    declineRequest(request) {
      this.updateRequest(
        request,
        {
          attributes: { request_status: "declined" },
          verify: "isDeclined",
        }
      )
    },

    updateRequest(request, options) {
      this.$store.dispatch('updateRequest', {
        request,
        options,
      }).then((updatedRequest) => {
        swal({
          text: `You ${updatedRequest.request_status}  ` +
                `the request from ${updatedRequest.requestor_name}`,
        })
      }).catch((req) => {
        console.error(req)
        swal({ text: "There was an error. Ask the dev team for help." })
      })
    },

    buildReviewHTML(request) {
      let html = '<ul class="list--reset">'

      request.requestor_meta.requesting_regions.forEach((region) => {
        html += `<li key="${region}">`
        html += region
        html += '</li>'
      })

      html += '</ul>'

      html += `<p>${request.requestor_message}</p>`

      return html
    },
  },
}
</script>

<style scoped lang="scss">
</style>