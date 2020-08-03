<template>
  <attendee-search
    type="team"
    add-btn-text="+ Add teams"
    search-placeholder="Search by team or submission name"
    :handleSelection="handleSelection"
    :handleDeselection="handleDeselection"
    :event="event"
  >
    <template slot="table-headers">
      <th>Name</th>
      <th>Division</th>
      <th colspan="2">Submission</th>
    </template>

    <template slot="table-rows" slot-scope="props">
      <td>{{ props.item.name }}</td>
      <td>{{ props.item.division }}</td>
      <td>{{ props.item.submission.name }}</td>
    </template>

    <template slot="no-results">
      <p>There are no more teams available to add to your event.</p>

      <p>
        Teams must not be attending other events,
        and must have started their submission.
      </p>

      <p>
        You can try searching for teams that are not in your region,
        but are close enough to travel to your event.
      </p>
    </template>
  </attendee-search>
</template>

<script>
  import EventBus from '../../components/EventBus';

  import AttendeeSearch from './AttendeeSearch'

  export default {
    components: {
      AttendeeSearch,
    },

    props: ["eventBusId", "event"],

    methods: {
      handleSelection (item) {
        EventBus.$emit("TeamSearch.selected-" + this.eventBusId, item);

        this.$store.commit('addTeam', item)
      },

      handleDeselection (item) {
        EventBus.$emit("TeamSearch.deselected-" + this.eventBusId, item);

        this.$store.commit('removeTeam', item)
      },
    },
  };
</script>
