<template>
  <div>
    <PasswordValidation />
  </div>
</template>

<script>
import PasswordValidation from './components/PasswordValidation'

export default {
  name: 'app',

  components: {
    PasswordValidation,
  },

  data () {
    return {}
  },
}
</script>

<style lang="scss" scoped>
</style>