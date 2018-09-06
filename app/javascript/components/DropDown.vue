<template>
  <div class="drop-down" v-click-outside="collapseDropDown">
    <a @click.stop.prevent="toggleCollapse">
      {{ label }}
      <icon
        :title="caretTitle"
        :name="caretIcon"
        color="000000"
        :size="12"
      />
    </a>
    <transition name="collapse">
      <div class="drop-down__content" v-show="expanded">
        <slot></slot>
      </div>
    </transition>
  </div>
</template>

<script>
import Icon from 'components/Icon'
import ClickOutside from 'directives/click-outside'

export default {
  name: 'top-section-header',

  directives: {
    'click-outside': ClickOutside,
  },

  components: {
    Icon,
  },

  props: {
    label: {
      type: String,
      required: true,
    },
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
    collapseDropDown () {
      this.expanded = false
    },

    toggleCollapse () {
      this.expanded = !this.expanded
    },
  },
}
</script>

<style lang="scss" scoped>
@import '../../assets/stylesheets/_variables';

.drop-down {
  position: relative;
}

.drop-down__content {
  position: absolute;
  z-index: 9999;
  background: #fff;
  margin-top: 1em;
  padding: 1em;
  border-radius: $radius-default;
  border: 1px solid rgba(0, 0, 0, 0.2);
  box-shadow: $shadow-small;
}

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
