<template>
  <div class="grid grid--bleed submission-pieces">
    <div class="grid__col-6 grid__col--bleed-y marine-row">
      <h4 class="code_checklist-header">
        Technical Components
      </h4>

      <dl v-if="submission.code_checklist.technical.length">
        <template v-for="item in submission.code_checklist.technical">
          <dt>{{ item.label }}</dt>
          <dd>{{ item.explanation }}</dd>
        </template>
      </dl>

      <p v-else>No use of technical components was indicated.</p>
    </div>

    <div class="grid__col-6 grid__col--bleed-y marine-row">
      <h4 class="code_checklist-header">
        Databases and Connectivity
      </h4>

      <dl v-if="submission.code_checklist.database.length">
        <template v-for="item in submission.code_checklist.database">
          <dt>{{ item.label }}</dt>
          <dd>{{ item.explanation }}</dd>
        </template>
      </dl>

      <p v-else>No use of database and connectivity was indicated.</p>

      <h4 class="code_checklist-header">
        Mobile Features
      </h4>

      <dl v-if="submission.code_checklist.mobile.length">
        <template v-for="item in submission.code_checklist.mobile">
          <dt>{{ item.label }}</dt>
          <dd>{{ item.explanation }}</dd>
        </template>
      </dl>

      <p v-else>No use of mobile features was indicated.</p>
    </div>

    <div class="grid__col-12 grid__col--bleed-y white-row">
      <h4 class="code_checklist-header">
        Pictures of the process
      </h4>

      <div
        v-if="submission.code_checklist.process.length"
        class="grid grid--bleed"
      >
        <dl
          class="grid__col-6"
          v-for="item in submission.code_checklist.process"
        >
          <dt>{{ item.label }}</dt>

          <dd class="img-modal">
            <img
              :src="item.display"
              :data-modal-url="item.display"
              class="thumbnail-md thumbnail-process-pic"
            />
          </dd>
        </dl>
      </div>

      <p v-else>No pictures of the process were uploaded.</p>
    </div>
  </div>
</template>

<script>
import { mapState } from 'vuex'

export default {
  computed: mapState(['submission']),
}
</script>

<style lang="scss" scoped>
.marine-row {
  background: #4BC2C6;
  padding: 1rem;
  min-height: 240px;
  color: black;

  > div {
    align-self: center;
  }

  h4 {
    margin: 0 0 0.5rem;
    color: black;
    -webkit-font-smoothing: antialiased;
  }

  dt {
    color: #e6e6e5;
    font-weight: normal;
  }

  p,
  dd {
    margin: 0 0 1rem;
  }
}
</style>
