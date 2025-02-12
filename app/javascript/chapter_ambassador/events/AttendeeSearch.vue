<template>
  <div class="grid">
    <div class="grid__col-auto grid__col--bleed-y">
      <p v-if="canAddTeamsToEvents">
        <button
          class="button button--remove-bg"
          v-show="!searching"
          @click="searching = true"
        >
          {{ addBtnText }}
        </button>
      </p>

      <p v-else class="color--danger">
        New teams cannot be added to events at this time.
      </p>

      <div class="modal-container" v-show="searching">
        <div class="modal">
          <div v-if="eventAtCapacity()" class="margin--b-xlarge">
            <div class="flash flash--error margin--none">
              This event is currently at capacity. No additional teams can be
              added.
            </div>
          </div>

          <input
            type="search"
            :placeholder="searchPlaceholder"
            v-model="query"
          />

          <div class="align-center padding-small" v-show="fetching">
            <icon class="spin" name="spinner" />
          </div>

          <div class="padding-small" v-show="!fetching && !items.length">
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
                    v-tooltip="selectionDisabledTooltip"
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
            <button class="button--unmask" @click="searching = false">
              Done
            </button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from "axios";
import debounce from "lodash/debounce";

import { airbrake } from "utilities/utilities";
import Icon from "../../components/Icon";
import Attendee from "./Attendee";
import EventBus from "../../components/EventBus";

export default {
  components: {
    Icon,
  },

  data() {
    return {
      query: "",
      searching: false,
      fetching: false,
      items: [],
      selectableItems: [],
      canAddTeamsToEvents: false,
    };
  },

  props: {
    addBtnText: String,
    searchPlaceholder: String,
    handleSelection: {
      type: Function,
      required: true,
    },
    handleDeselection: {
      type: Function,
      required: true,
    },
    event: {
      type: Object,
      required: true,
    },
    type: {
      type: String,
      required: true,
    },
  },

  async created() {
    EventBus.$on(
      [
        "EventTeamList.saveAssignments",
        "EventJudgeList.saveAssignments",
        "EventTeamList.removeTeam",
        "EventJudgeList.removeJudge",
      ],
      () => {
        this.fetchRemoteItems();
      }
    );

    this.debouncedFetchRemoteItems = debounce(() => {
      this.fetchRemoteItems({ expandSearch: 1 });
    }, 300);

    await this.getRegionalPitchEventSettings();
  },

  computed: {
    filteredItems() {
      if (this.type == "team") {
        return Array.from(this.selectableItems || []).filter((i) => {
          return (
            i.selected ||
            !Array.from(this.$store.state.teams || [])
              .map((t) => t.id)
              .includes(i.id)
          );
        });
      } else {
        return this.selectableItems;
      }
    },

    selectionDisabledTooltip() {
      if (!this.eventAtCapacity()) {
        return false;
      }

      return "You have reached the maximum number of teams for this event";
    },
  },

  watch: {
    query(val) {
      if (val.length >= 3) {
        this.onQueryChange();
      }
    },

    searching(current) {
      if (current && !this.items.length) this.fetchRemoteItems();
    },
  },

  methods: {
    toggleSelection(item) {
      if (item.selected) {
        this.handleDeselection(item);
      } else if (!this.eventAtCapacity()) {
        this.handleSelection(item);
      }
    },

    eventAtCapacity() {
      if (this.type !== "team") {
        return false;
      }

      return (
        Boolean(this.event.capacity) &&
        this.event.selectedTeams.length >= this.event.capacity
      );
    },

    onQueryChange() {
      this.debouncedFetchRemoteItems();
    },

    fetchRemoteItems(opts) {
      if (this.fetching) return false;

      opts = opts || { expandSearch: 0 };

      const vm = this,
        url =
          "/chapter_ambassador" +
          "/possible_event_attendees.json" +
          "?type=" +
          this.type +
          "&event_id=" +
          this.event.id +
          "&query=" +
          encodeURIComponent(this.query) +
          "&expand_search=" +
          opts.expandSearch;

      $.ajax({
        url: url,

        beforeSend: () => {
          vm.fetching = true;
        },

        success: (json) => {
          vm.$set(vm, "items", []);
          vm.$set(vm, "selectableItems", []);

          Array.from(json.data || []).forEach((obj) => {
            // Need to massage this data since serializers modify the JSON structure
            obj.attributes.id = obj.id;
            const item = new Attendee(obj.attributes);
            let idx;

            if (vm.type === "team") {
              idx = Array.from(vm.items || []).findIndex(
                (i) => i.id === item.id
              );
            } else {
              idx = Array.from(vm.items || []).findIndex(
                (i) => i.email === item.email
              );
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
    async getRegionalPitchEventSettings() {
      try {
        const response = await axios.get("/api/regional_pitch_events/settings");

        this.canAddTeamsToEvents = response.data.canAddTeamsToEvents;
      } catch (error) {
        airbrake.notify({
          error: `[REGIONAL PITCH EVENTS] Error getting event settings - ${error.response.data}`,
        });
      }
    },
  },
};
</script>

<style lang="scss" scoped></style>
