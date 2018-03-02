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
        <div
          class="modal"
          v-show="searching"
        >
          <input
            type="search"
            placeholder="Search by team or submission name"
            v-model="query"
          />

          <div class="overflow-scroll">
            <table class="width-full-container">
              <thead>
                <tr>
                  <th>Name</th>
                  <th colspan="2">Submission</th>
                </tr>
              </thead>

              <tbody>
                <tr
                  class="cursor-pointer"
                  v-for="item in filteredItems"
                  @click="item.toggleSelection"
                >
                  <td>
                    {{ item.name }}
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
        items: [],
        filteredItems: [],
      };
    },

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
      },

      searching (current) {
        const vm = this,
              url = "/regional_ambassador" +
                    "/possible_event_attendees.json" +
                    "?type=team";

        if (current) {
          if (!vm.items.length) {
            $.get(url, json => {
              _.each(json, obj => {
                const item = new Attendee(obj);
                vm.items.push(item);
              });

              vm.filteredItems = vm.items;
            })
          }
        }
      },
    },

    methods: {
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

    &:hover,
    &:hover td {
      background: LavenderBlush;
    }
  }

  .light-opacity {
    opacity: 0.2;
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

  .modal-container {
    @extend .display-flex-center;
    @extend .position-fixed;
    @extend .z-index-penultimate;
    @extend .width-full-screen;
    @extend .height-full-screen;
    @extend .background-semi-transparent-dark;
  }
</style>
