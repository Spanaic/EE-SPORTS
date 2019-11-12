<template>
  <div>
    <form action @submit.prevent="hundleSubmit">
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
  mounted() {
    axios
      .get(`/end_users/${this.$route.params.userId}/edit`)
      .then(res => {
        console.log(res);
        this.end_user = res.data;
      })
      .catch(function(error) {
        console.log("ERROR!! occurred in Backend.", error);
      });
  }
  //   mounted: async function() {
  //     const res = await axios.get(`/end_users/${this.$route.params.id}`);
  //     this.end_user = res.data;
  //   }
};
</script>

<style>
</style>