<template>
  <div class="grid">
    <div class="grid__col-auto grid__col--bleed-y">
      <p>
        <button
          class="button button--remove-bg"
          v-show="!searching"
          @click="searching = true"
        >
          {{ addBtnText }}
        </button>
      </p>

      <div
        class="modal-container"
        v-show="searching"
      >
        <div class="modal">
          <input
            type="search"
            :placeholder="searchPlaceholder"
            v-model="query"
          />

          <div
            class="align-center padding-small"
            v-show="fetching"
          >
            <icon class="spin" name="spinner" />
          </div>

          <div
            class="padding-small"
            v-show="!fetching && !items.length"
          >
            <slot name="no-results" />
          </div>

          <div v-show="!fetching && items.length" class="overflow-scroll">
            <table class="width-full-container headers--left-align">
              <thead>
                <tr>
                  <slot name="table-headers" />
                </tr>
              </thead>

              <tbody>
                <tr
                  class="cursor-pointer"
                  v-for="item in filteredItems"
                  :key="item.id"
                  @click="toggleSelection(item)"
                >
                  <slot name="table-rows" :item="item" />

                  <td
                    class="light-opacity"
                    v-show="!item.selected"
                  >
                    <icon name="check-circle-o" />
                  </td>

                  <td v-show="item.selected">
                    <icon name="check-circle" color="228b22" />
                  </td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="modal-footer">
            <button
              class="button--unmask"
              @click="searching = false"
            >
              Done
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import _ from "lodash";

  import Icon from "./Icon";
  import Attendee from "./Attendee";

  export default {
    data () {
      return {
        query: "",
        searching: false,
        fetching: true,
        items: [],
        selectableItems: [],
      };
    },

    props: [
      "type",
      "addBtnText",
      "searchPlaceholder",
      "handleSelection",
      "handleDeselection",
      "eventId"
    ],

    computed: {
      filteredItems () {
        if (this.type == 'team') {
          return _.filter(this.selectableItems, i => {
            return i.selected ||
              !_.map(this.$store.state.teams, 'id').includes(i.id)
          })
        } else {
          return this.selectableItems
        }
      }
    },

    components: {
      Icon,
    },

    watch: {
      query (val) {
        this.selectableItems = _.filter(this.items, item => {
          return item.matchesQuery(val);
        });

        if (val.length >= 3 && !this.selectableItems.length)
          _.debounce(
            this.fetchRemoteItems.bind(this, { expandSearch: 1 }),
            300
          )();
      },

      searching (current) {
        if (current && !this.items.length)
          this.fetchRemoteItems();
      },
    },

    methods: {
      toggleSelection (item) {
        if (item.selected) {
          this.handleDeselection(item);
        } else {
          this.handleSelection(item);
        }
      },

      fetchRemoteItems (opts) {
        opts = opts || { expandSearch: 0 };

        const vm = this,
              url = "/regional_ambassador" +
                    "/possible_event_attendees.json" +
                    "?type=" + this.type +
                    "&event_id=" + this.eventId +
                    "&query=" + encodeURIComponent(this.query) +
                    "&expand_search=" + opts.expandSearch;

        $.ajax({
          url: url,

          beforeSend: () => {
            vm.fetching = true;
          },

          success: (json) => {
            _.each(json, obj => {
              const item = new Attendee(obj)
              let source = vm.items

              if (vm.type === 'team')
                source = vm.$store.state.teams

              const idx = _.findIndex(source, i => {
                      return i.id === item.id;
                    });

              if (idx === -1) {
                vm.items.push(item);
                vm.selectableItems.push(item);
              }
            });
          },

          complete: () => {
            vm.fetching = false;
          },
        });
      },
    },
  };
</script>

<style lang="scss" scoped>
  [type=search] {
    font-size: 0.95rem;
    padding: 0.25rem 1rem;
    border-radius: 50vh;
    background: url("https://icongr.am/fontawesome/search.svg?size=12")
                no-repeat
                right 0.5rem center;
  }

  .position-fixed {
    position: fixed;
    top: 0;
    left: 0;
  }

  .headers--left-align {
    th {
      text-align: left;
    }
  }

  .width-medium {
    width: 60vw;
  }

  .width-full-screen {
    width: 100vw;
  }

  .width-full-container {
    width: 100%;
  }

  .height-full-screen {
    height: 100vh;
  }

  .background-white {
    background: white;
  }

  .background-semi-transparent-dark {
    background: rgba(0, 0, 0, 0.7);
  }

  .display-flex {
    display: flex;
  }

  .display-flex-center {
    @extend .display-flex;
    align-items: center;
    justify-content: center;
  }

  .padding-small {
    padding: 0.5rem;
  }

  .align-center {
    text-align: center;
  }

  .shadow-subtle-white {
    box-shadow: 0 0 2rem rgba(255, 255, 255, 0.5);
  }

  .z-index-penultimate {
    z-index: 999998;
  }

  .z-index-max {
    z-index: 999999;
  }

  .border-radius-small {
    border-radius: 0.2rem;
  }

  .overflow-scroll {
    max-height: 50vh;
    overflow-y: scroll;
  }

  .cursor-pointer {
    cursor: pointer;
    transition: background 0.2s, color 0.2s;
  }

  tr.cursor-pointer {
    &:hover,
    &:hover td {
      background: LavenderBlush;
    }
  }

  button.cursor-pointer {
    &:hover,
    &:hover td {
      color: black;
    }
  }

  .light-opacity {
    opacity: 0.2;
  }

  .background-none {
    background: none;
  }

  .border-none {
    border: none;
  }

  .color-shamrock {
    color: #5ABF94;
  }

  .text-uppercase {
    text-transform: uppercase;
  }

  .font-bold {
    font-weight: bold;
  }

  .button--unmask {
    @extend .background-none;
    @extend .border-none;
    @extend .color-shamrock;
    @extend .text-uppercase;
    @extend .font-bold;
    @extend .cursor-pointer;
  }

  .modal-container {
    @extend .display-flex-center;
    @extend .position-fixed;
    @extend .z-index-penultimate;
    @extend .width-full-screen;
    @extend .height-full-screen;
    @extend .background-semi-transparent-dark;
  }

  .modal {
    @extend .width-medium;
    @extend .padding-small;
    @extend .background-white;
    @extend .shadow-subtle-white;
    @extend .border-radius-small;
    @extend .z-index-max;
    display: block;
  }

  .modal-footer {
    margin: 0 -0.5rem -0.5rem;
    box-shadow: -0.1rem 0 1rem rgba(0, 0, 0, 0.2);
    padding: 0.25rem 0.5rem;
    text-align: right;
  }
</style>
