import Vue from "vue"

export const TabLink = Vue.component('tab-link', {
  props: ['tabId', 'label'],

  template: `
    <li class="tab-link">
      <button
        role="button"
        class="tab-button"
        :data-tab-id="tabId"
      >
        {{ label }}
      </button>
    </li>
  `,
})