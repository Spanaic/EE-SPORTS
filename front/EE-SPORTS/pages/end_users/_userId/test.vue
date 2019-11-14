<template>
  <div>
    <h1>{{ end_user.email }}</h1>
    <h2>{{ end_user.name }}</h2>
    <h2>{{ end_user.profile_name}}</h2>
    <nuxt-link :to="`/end_users/${this.end_user.id}/edit`">プロフィール編集</nuxt-link>
    <img :src="`http://localhost:3001/end_users/${end_user.profile_image_name}`" alt />
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import vuex from "vuex";

export default {
  data() {
    return {
      end_user: {}
      // current_user: this.$store.state.user
    };
  },
  // async mounted () {
  //   try {
  //     const { data } = await axios.get(`/end_users/${this.$route.params.id}`);
  //     cosole.log(data);
  //     this.end_user = data;
  //   } catch (err) {
  //     alert(err);
  //   }
  // }
  mounted() {
    axios
      .get(`/end_users/${this.$route.params.id}`)
      .then(res => {
        console.log(res);
        this.end_user = res.data;
      })
      .catch(function(error) {
        console.log("ERROR!! occurred in Backend.", error);
      });
  }
};
</script>

<style>
</style>