<template>
  <attendee-search
    type="account"
    add-btn-text="+ Add judges"
    search-placeholder="Search by name or email"
    :handleSelection="handleSelection"
    :handleDeselection="handleDeselection"
    :event="event"
  >
    <template slot="table-headers">
      <th>Name</th>
      <th colspan="2">Email</th>
    </template>

    <template slot="table-rows" slot-scope="props">
      <td>{{ props.item.name }}</td>
      <td>{{ props.item.email }}</td>
    </template>

    <div slot="no-results">
      <p>There are no judges available to add to your event.</p>

      <p>Judges for live events cannot also be mentors.</p>

      <p>
        You can try searching for judges that are
        not in your region, but are close enough
        to travel to your event.
      </p>

      <p>You can enter a new email address to invite a new judge.</p>
    </div>
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
        EventBus.$emit("JudgeSearch.selected-" + this.eventBusId, item);
      },

      handleDeselection (item) {
        EventBus.$emit("JudgeSearch.deselected-" + this.eventBusId, item);
      },
    }
  };
</script>
