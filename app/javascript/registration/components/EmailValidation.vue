<template>
  <form>
    <label for="email">Email</label>
    <input type="email" name="email" v-model="email" />
  </form>
</template>

<script>
export default {
  name: 'email-validation',

  data () {
    return {
      email: '',
    }
  },
}
</script>