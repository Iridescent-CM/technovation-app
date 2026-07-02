<template>
  <div
    class="h-auto mb-auto rounded-md border-solid border-4 border-energetic-blue"
  >
    <div class="sm-header-wrapper">
      <p id="energetic-heading" class="font-bold">{{ heading }}</p>
    </div>
    <div class="p-8 flex-row justify-between">
      <slot></slot>
    </div>
  </div>
</template>

<script>
export default {
  name: "EnergeticContainer",
  props: ["heading"],
};
</script>
