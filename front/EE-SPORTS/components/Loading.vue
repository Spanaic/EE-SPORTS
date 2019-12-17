<template>
  <v-app>
    <div class="text-center">
      <v-progress-circular class="circle" :size="70" :width="7" color="purple" indeterminate></v-progress-circular>
    </div>
  </v-app>
</template>

<script>
export default {
  created() {
    console.log("loading");
  }
};
</script>

<style scoped>
.v-progress-circular {
  margin: 1rem;
}
.circle {
  width: 100vw;
  height: 100vh;
}
</style>