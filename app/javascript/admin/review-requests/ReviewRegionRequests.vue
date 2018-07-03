<template>
  <div v-if="isLoading" class="loading">
    Loading...
  </div>

  <div v-else-if="hasError" class="error">
    Error. Please let the dev team know.
  </div>

  <div v-else>
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
          <h3>Requesting</h3>

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
          <button @click="reviewRequest(request)">Review</button>
        </div>
      </div>
    </template>

    <div class="padding-medium color--light weight--bold align--center">
      No more pending requests
    </div>
  </div>
</template>

<script>
import axios from 'axios'

import Request from './models/request'

export default {
  data () {
    return {
      isLoading: true,
      hasError: false,
      requests: [],
    }
  },

  props: ['sourceUrl'],

  created () {
    this.loadData()
  },

  methods: {
    loadData () {
      axios.get(this.sourceUrl).then(({ data }) => {
        data.data.forEach((request) => {
          const myRequest = new Request(request)
          this.requests.push(myRequest)
        })

        this.isLoading = false
      }).catch((err) => {
        console.error(err)
        this.isLoading = false
        this.hasError = true
      })
    },

    reviewRequest(request) {
      let html = `<p>${request.requestor_message}</p>`

      html += '<ul class="list--reset">'

      request.requestor_meta.requesting_regions.forEach((region) => {
        html += `<li key="${region}">`
        html += region
        html += '</li>'
      })

      html += '</ul>'

      swal({
        title: request.requestor_name,
        html: html,
      })
    },
  },
}
</script>

<style scoped lang="scss">
h1,
h2,
h3 {
  font-size: 1rem;
  text-align: left;
  margin: 0;
  padding: 0;
}

h2 {
  color: #444;
  opacity: 0.5;
}

h3 {
  color: #006540;
}

ul {
  font-size: 0.9rem;
}

button {
  background: none;
  border: 2px solid #006540;
  color: #006540;
  border-radius: 500px;
  cursor: pointer;
  padding: 0.5rem 1rem;
  opacity: 0.5;
  transition: opacity 0.2s, background-color 0.2s, color 0.2s;
  font-weight: bold;
  font-size: 0.9rem;
  outline: none;
  text-transform: uppercase;

  &:hover,
  &:active,
  &:focus {
    opacity: 1;
    background: #006540;
    color: white;
  }
}

.grid-list {
  display: grid;
  grid-template-columns: repeat(11, 1fr);
  grid-gap: 1rem 0.5rem;
  margin: 0 0 1rem;
  padding: 0.5rem;
  transition: background-color 0.2s;

  &:hover {
    background: rgba(#006540, 0.2);
  }
}

.grid-list__col-1 { grid-column: span 1; }
.grid-list__col-2 { grid-column: span 2; }
.grid-list__col-3 { grid-column: span 3; }
.grid-list__col-4 { grid-column: span 4; }
.grid-list__col-5 { grid-column: span 5; }
.grid-list__col-6 { grid-column: span 6; }
.grid-list__col-7 { grid-column: span 7; }
.grid-list__col-8 { grid-column: span 8; }
.grid-list__col-9 { grid-column: span 9; }
.grid-list__col-10 { grid-column: span 10; }
.grid-list__col-11 { grid-column: span 11; }
.grid-list__col-12 { grid-column: span 12; }

.color--light {
  color: #444;
  opacity: 0.4;
}

.weight--bold {
  font-weight: bold;
}

.align--center {
  text-align: center;
}

.padding--medium {
  padding: 1rem;
}
</style>