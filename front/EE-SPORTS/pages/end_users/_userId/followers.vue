<template>
  <div>
    <div v-for="(follower, i) in followers" :key="i">{{follower}}</div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      followers: []
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    }
  },
  async created() {
    try {
      const res = await axios.get(
        `/end_users/${this.currentUser.id}/followers`,
        currentUser.id
      );
      this.followers = res.data;
    } catch (err) {
      alert(err);
    }
  }
};
</script>

<style>
</style>