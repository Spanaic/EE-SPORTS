<template>
  <div>
    <div v-for="(end_user, i) in end_users" :key="i">
      {{ end_user.name }}
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
  mounted: async function() {
    const res = await axios.get("/end_users.json");
    this.end_users = res.data.users;
    console.log(res.data.users);
  }
};
</script>

<style>
</style>