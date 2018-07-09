<template>
  <div v-if="isLoading" class="loading">
    Loading...
  </div>

  <div v-else-if="hasError" class="error">
    Error. Please let the dev team know.
  </div>

  <div v-else class="grid grid--justify-space-around">
    <div class="grid__col-10 tabs" id="admin-requests-tabs">
      <ul class="tab-menu">
        <tab-link
          tab-id="pending"
          :label="`Pending (${pendingRequests.length})`"
        />

        <tab-link
          tab-id="approved"
          :label="`Approved (${approvedRequests.length})`"
        />

        <tab-link
          tab-id="declined"
          :label="`Declined (${declinedRequests.length})`"
        />
      </ul>

      <div class="content">
        <div class="tab-content panel" id="pending">
          <review-region-requests
            :requests="pendingRequests"
            request-status="pending"
          />
        </div>

        <div class="tab-content panel" id="approved">
          <review-region-requests
            :requests="approvedRequests"
            request-status="approved"
          />
        </div>

        <div class="tab-content panel" id="declined">
          <review-region-requests
            :requests="declinedRequests"
            request-status="declined"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import $ from 'jquery'

import { mapState } from 'vuex'
import { TabLink } from '../../components/tabs'
import ReviewRegionRequests from './components/ReviewRegionRequests'

import axios from 'axios'

const csrfTokenMetaTag = document.querySelector('meta[name="csrf-token"]')

if (csrfTokenMetaTag) {
  axios.defaults.headers.common = {
    'X-Requested-With': 'XMLHttpRequest',
    'X-CSRF-TOKEN' : csrfTokenMetaTag.getAttribute('content')
  }
}

export default {
  data () {
    return {
      isLoading: true,
      hasError: false,
    }
  },

  components: {
    TabLink,
    ReviewRegionRequests,
  },

  computed: {
    ...mapState(['allRequests']),

    pendingRequests () {
      return this.allRequests.filter(r => r.isPending())
    },

    approvedRequests () {
      return this.allRequests.filter(r => r.isApproved())
    },

    declinedRequests () {
      return this.allRequests.filter(r => r.isDeclined())
    },
  },

  created () {
    this.$store.dispatch("init").then(() => {
      this.isLoading = false
    }).catch((err) => {
      console.error(err)
      this.isLoading = false
      this.hasError = true
    })

    $(document).trigger('vue:created')
  },

  updated () {
    $(document).trigger('vue:updated')
  },
}
</script>

<style lang="scss">
.admin-requests-list {
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
}
</style>