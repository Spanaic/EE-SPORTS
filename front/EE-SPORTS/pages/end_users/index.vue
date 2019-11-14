<template>
  <div>
    <div v-for="(end_user, i) in end_users" :key="i">
      <!-- {{ end_user.name }} -->
      <nuxt-link :to="`/end_users/${end_user.id}`">{{ end_user.name }}</nuxt-link>
    </div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      end_users: []
    };
  },
  created: async function() {
    const res = await axios.get("/end_users");
    this.end_users = res.data[1];
    console.log(res.data[1]);
  }
};
</script>

<style>
</style>