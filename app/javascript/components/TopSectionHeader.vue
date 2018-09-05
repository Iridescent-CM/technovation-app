<template>
  <div class="grid__cell">
    <h1 class="page-heading">
      <slot name="title"></slot>
      <slot name="links"></slot>
      <small>
        <a @click.stop.prevent="toggleCollapse">
          More Information
          <icon
            :title="caretTitle"
            :name="caretIcon"
            color="000000"
            :size="12"
          />
        </a>
      </small>
    </h1>
    <transition name="collapse">
      <div v-show="expanded">
        <slot name="content"></slot>
      </div>
    </transition>
  </div>
</template>

<script>
import Icon from 'components/Icon'

export default {
  name: 'top-section-header',

  components: {
    Icon,
  },

  data () {
    return {
      expanded: false,
    }
  },

  computed: {
    caretTitle () {
      return this.expanded ? 'Collapse' : 'Expand'
    },

    caretIcon () {
      return this.expanded ? 'caret-up' : 'caret-down'
    },
  },

  methods: {
    toggleCollapse () {
      this.expanded = !this.expanded
    },
  },
}
</script>

<style lang="scss" scoped>
.collapse-enter-active {
  animation: scale .2s;
}

.collapse-leave-active {
  animation: scale .2s reverse;
}

@keyframes scale {
  0% {
    transform-origin: top left;
    transform: scale(0);
  }

  100% {
    transform-origin: top left;
    transform: scale(1);
  }
}
</style>
