<template>
  <p class="text-sm">&copy; {{currentYear}} Technovation. All Rights Reserved. Technovation is a 501c3 nonprofit organization in the United States.</p>
</template>

<script>
export default {
  data() {
    return {
      currentYear: new Date().getFullYear(),
    };
  }
};
</script>