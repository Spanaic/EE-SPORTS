<template>
  <div>
    <form action @submit.prevent="handleSubmit">
      <input type="text" v-model="end_user.email" />
      <input type="text" v-model="end_user.name" />
      <input type="text" v-model="end_user.profile_name" />
      <input type="submit" />
    </form>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      end_user: {}
    };
  },
  async created() {
    const res = await axios.get(`/end_users/${this.$route.params.id}`);
    this.end_user = res.data;
    await this.$store.dispatch("notificationsCheck", this.$store.state.user);
  },
  // mounted: async function() {
  //   const res = await axios.get(`/end_users/${this.$route.params.id}`);
  //   this.end_user = res.data;
  // },
  async mounted() {
    console.log("notificationsCheck", this.$store.state.user);
    await this.$store.dispatch("notificationsCheck", this.$store.state.user);
  }
};
</script>

<style>
</style>