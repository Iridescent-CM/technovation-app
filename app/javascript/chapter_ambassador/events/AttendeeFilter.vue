<template>
  <div class="modal-container">
    <div class="modal">
      <input
        ref="filterInput"
        v-model="filterTxt"
        type="search"
        :placeholder="placeholder"
      />

      <div v-show="items.length" class="overflow-scroll">
        <table class="width-full-container headers--left-align">
          <thead>
            <tr>
              <th>Name</th>
              <th colspan="2">{{ col2Header }}</th>
            </tr>
          </thead>

          <tbody>
            <tr
              v-for="item in items"
              :key="item.id"
              class="cursor-pointer"
              @click="handleSelection(item)"
            >
              <td>{{ item.name }}</td>

              <slot name="col-2" v-bind="item"></slot>

              <td v-show="!isAssigned(item, parentItem)" class="light-opacity">
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
        <button class="button--unmask" @click="handleClose">Done</button>
      </div>
    </div>
  </div>
</template>

<script>
import Icon from "../../components/Icon";

export default {
  name: "AttendeeList",

  components: {
    Icon,
  },

  props: [
    "parentItem",
    "childItems",
    "placeholder",
    "col2Header",
    "handleSelection",
    "handleClose",
    "isAssigned",
  ],

  data() {
    return {
      filterTxt: "",
      items: this.childItems,
    };
  },

  watch: {
    filterTxt() {
      this.items = Array.from(this.childItems || []).filter((i) =>
        i.matchesQuery(this.filterTxt)
      );
    },
  },

  mounted() {
    this.$refs.filterInput.focus();
  },
};
</script>
