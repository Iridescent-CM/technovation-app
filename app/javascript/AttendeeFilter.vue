<template>
  <div class="modal-container">
    <div class="modal">
      <input
        ref="filterInput"
        type="search"
        :placeholder="placeholder"
        v-model="filterTxt"
      />

      <div
        v-show="childItems.length"
        class="overflow-scroll"
      >
        <table class="width-full-container headers--left-align">
          <thead>
            <tr>
              <th>Name</th>
              <th colspan="2">Email</th>
            </tr>
          </thead>

          <tbody>
            <tr
              class="cursor-pointer"
              v-for="item in childItems"
              :key="item.id"
              @click="handleSelection(item)"
            >
              <td>{{ item.name }}</td>
              <td>{{ item.submission.name }}</td>

              <td
                class="light-opacity"
                v-show="!item.isAssignedToJudge(parentItem)"
              >
                <icon name="check-circle-o" />
              </td>

              <td v-show="item.isAssignedToJudge(parentItem)">
                <icon name="check-circle" color="228b22" />
              </td>
            </tr>
          </tbody>
        </table>
      </div>

      <div class="modal-footer">
        <button
          class="button--unmask"
          @click="handleClose"
        >
          Done
        </button>
      </div>
    </div>
  </div>
</template>

<script>
  import _ from 'lodash';

  import Icon from "./Icon";

  export default {
    name: "AttendeeList",

    data () {
      return {
        filterTxt: "",
      }
    },

    props: [
      'parentItem',
      'childItems',
      'placeholder',
      'handleSelection',
      'handleClose'
    ],

    components: {
      Icon,
    },

    mounted () {
      this.$refs.filterInput.focus()
    },
  }
</script>
