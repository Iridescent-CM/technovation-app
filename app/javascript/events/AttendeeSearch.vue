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

  import Icon from "../components/Icon";

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
              let idx = -1

              if (vm.type === 'team') {
                idx = _.findIndex(vm.$store.state.teams, i => {
                  return i.id === item.id;
                });
              }

              if (idx === -1) {
                idx = _.findIndex(vm.items, i => {
                  return i.email === item.email;
                });
              }

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
</style>
