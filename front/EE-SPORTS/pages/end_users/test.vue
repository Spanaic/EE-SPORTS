<template>
  <div>
    <h1>{{ end_user.email }}</h1>
    <h2>{{ end_user.name }}</h2>
    <h2>{{ end_user.profile_name}}</h2>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import vuex from "vuex";

export default {
  data() {
    return {
      end_user: {}
      //   current_user: this.$store.state.user
    };
  },
  mounted: async () => {
    try {
      const { data } = await axios.get(`/end_users/${this.$route.params.id}`, {
        params: this.$route.params.id
      });
      cosole.log(data);
      //   this.end_user = data;
    } catch (err) {
      alert(err);
    }
  }
};
</script>

<style>
</style>