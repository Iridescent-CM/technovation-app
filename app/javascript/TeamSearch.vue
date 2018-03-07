<template>
  <div class="grid">
    <div class="grid__col-auto grid__col--bleed-y">
      <p>
        <button
          class="button button--remove-bg"
          v-show="!searching"
          @click="searching = true"
        >
          + Add teams
        </button>
      </p>

      <div
        class="modal-container"
        v-show="searching"
      >
        <div class="modal">
          <input
            type="search"
            placeholder="Search by team or submission name"
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
            <p>There are no teams available to add to your event.</p>

            <p>
              Teams must not be attending other events,
              and must have started their submission.
            </p>

            <p>
              You can try searching for teams that are not in your region,
              but are close enough to travel to your event.
            </p>
          </div>

          <div v-show="!fetching && items.length" class="overflow-scroll">
            <table class="width-full-container headers--left-align">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Division</th>
                  <th colspan="2">Submission</th>
                </tr>
              </thead>

              <tbody>
                <tr
                  class="cursor-pointer"
                  v-for="item in filteredItems"
                  :key="item.id"
                  @click="toggleSelection(item)"
                >
                  <td>
                    {{ item.name }}
                  </td>

                  <td>
                    {{ item.division }}
                  </td>

                  <td>
                    {{ item.submission.name }}
                  </td>

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

  import EventBus from "./EventBus";

  export default {
    data () {
      return {
        query: "",
        searching: false,
        fetching: true,
        items: [],
        filteredItems: [],
      };
    },

    props: ["eventBusId", "eventId"],

    components: {
      Icon,
    },

    watch: {
      query (val) {
        this.filteredItems = _.filter(this.items, item => {
          const pattern = new RegExp(val, "i");
          return item.name.match(pattern) ||
            item.submission.name.match(pattern);
        });

        if (val.length >= 3 && !this.filteredItems.length)
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
        let eventName;

        if (item.selected) {
          eventName = "TeamSearch.deselected-" + this.eventBusId;
        } else {
          eventName = "TeamSearch.selected-" + this.eventBusId;
        }

        EventBus.$emit(eventName, item);
      },

      fetchRemoteItems (opts) {
        opts = opts || { expandSearch: 0 };

        const vm = this,
              url = "/regional_ambassador" +
                    "/possible_event_attendees.json" +
                    "?type=team" +
                    "&event_id=" + this.eventId +
                    "&query=" + this.query +
                    "&expand_search=" + opts.expandSearch;

        $.ajax({
          url: url,

          beforeSend: () => {
            vm.fetching = true;
          },

          success: (json) => {
            _.each(json, obj => {
              const item = new Attendee(obj),
                    idx = _.findIndex(vm.items, i => {
                            return i.id === item.id;
                          });

              if (idx === -1) vm.items.push(item);
            });

            vm.filteredItems = vm.items;
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
    width: 40vw;
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
    max-height: 40vh;
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
