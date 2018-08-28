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
        v-show="items.length"
        class="overflow-scroll"
      >
        <table class="width-full-container headers--left-align">
          <thead>
            <tr>
              <th>Name</th>
              <th colspan="2">{{ col2Header }}</th>
            </tr>
          </thead>

          <tbody>
            <tr
              class="cursor-pointer"
              v-for="item in items"
              :key="item.id"
              @click="handleSelection(item)"
            >
              <td>{{ item.name }}</td>

              <slot name="col-2" v-bind="item"></slot>

              <td
                class="light-opacity"
                v-show="!isAssigned(item, parentItem)"
              >
                <icon name="check-circle-o" />
              </td>

              <td v-show="isAssigned(item, parentItem)">
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
  import Icon from "../../components/Icon";

  export default {
    name: "AttendeeList",

    data () {
      return {
        filterTxt: "",
        items: this.childItems,
      }
    },

    props: [
      'parentItem',
      'childItems',
      'placeholder',
      'col2Header',
      'handleSelection',
      'handleClose',
      'isAssigned'
    ],

    components: {
      Icon,
    },

    watch: {
      filterTxt () {
        this.items = Array.from(this.childItems || [])
                          .filter(i => i.matchesQuery(this.filterTxt))
      },
    },

    mounted () {
      this.$refs.filterInput.focus()
    },
  }
</script>
