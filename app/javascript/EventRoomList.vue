<template>
  <div class="grid">
    <div class="grid__col-12 grid__col--bleed-y">
      <h6 class="heading--reset">
        Rooms
        <span>({{ this.event.rooms.length }})</span>
      </h6>
    </div>

    <div class="grid__col-12 grid__col--bleed-y">
      hmmm...
    </div>
  </div>
</template>

<script>
  import _ from 'lodash';

  import EventBus from './EventBus';

  export default {
    data () {
      return {
        fetchingList: true,
      };
    },

    props: [
      'fetchListUrl',
      'saveAssignmentsUrl',
      'event',
    ],

    methods: {
      saveAssignments () {
        var form = new FormData();

        _.each(this.event.selectedJudges, (judge, idx) => {
          form.append(
            `event_assignment[invites][${idx}][]id`,
            judge.id
          )

          form.append(
            `event_assignment[invites][${idx}][]scope`,
            judge.scope
          )

          form.append(
            `event_assignment[invites][${idx}][]email`,
            judge.email
          )

          form.append(
            `event_assignment[invites][${idx}][]name`,
            judge.name
          )

          form.append(
            `event_assignment[invites][${idx}][]send_email`,
            judge.sendInvitation
          );
        });

        form.append("event_assignment[event_id]", this.event.id);

        $.ajax({
          method: "POST",
          url: this.saveAssignmentsUrl,
          data: form,
          contentType: false,
          processData: false,

          success: (resp) => {
            this.event.afterSave();
          },

          error: (err) => {
            console.log(err);
          },
        });
      },
    },

    computed: {
    },

    components: {
      App,
    },

    mounted () {
    },
  };
</script>

<style lang="scss" scoped>
</style>
