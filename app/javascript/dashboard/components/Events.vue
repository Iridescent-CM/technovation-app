<template>
  <div class="tabs tabs--vertical tabs--css-only grid">
    <div class="tabs__content grid__col-12 tabs__content--embedded">
      <div class="grid">
        <div class="grid__col-8">
          <slot name="events" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'events',
}
</script>