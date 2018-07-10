<template>
  <div v-if="isLoading" class="loading">
    Loading...
  </div>

  <div v-else-if="hasError" class="error">
    Error. Please let the dev team know.
  </div>

  <div v-else class="grid grid--justify-space-around">
    <div class="grid__col-10 tabs tabs--css-only">
      <ul class="tabs__menu">
        <router-link
          :to="{ name: 'pending' }"
          tag="li"
          class="tabs__menu-link"
          active-class="tabs__menu-link--active"
        >
          <button
            role="button"
            class="tabs__menu-button"
          >
            Pending ({{ pendingRequests.length }})
          </button>
        </router-link>

        <router-link
          :to="{ name: 'approved' }"
          tag="li"
          class="tabs__menu-link"
          active-class="tabs__menu-link--active"
        >
          <button
            role="button"
            class="tabs__menu-button"
          >
            Approved ({{ approvedRequests.length }})
          </button>
        </router-link>

        <router-link
          :to="{ name: 'declined' }"
          tag="li"
          class="tabs__menu-link"
          active-class="tabs__menu-link--active"
        >
          <button
            role="button"
            class="tabs__menu-button"
          >
            Declined ({{ declinedRequests.length }})
          </button>
        </router-link>
      </ul>

      <div class="content">
        <div class="tabs__tab-content panel">
          <router-view />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  data () {
    return {
      isLoading: true,
      hasError: false,
    }
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