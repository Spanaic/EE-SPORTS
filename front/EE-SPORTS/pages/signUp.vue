<template>
  <div>
    <form action="create" @submit.prevent="hundleSubmit">
      <label for="email">email</label>
      <input type="text" v-model="email" />
      <label for="password">password</label>
      <input type="text" v-model="password" />
      <label for="name">name</label>
      <input type="text" v-model="name" />
      <label for="profile_name">profile_name</label>
      <input type="text" v-model="profile_name" />
      <input type="submit" />
    </form>
    <button @click="googleLogIn">Googleアカウントで登録</button>
    <button @click="logOut">ログアウト</button>
    <nuxt-link to="/post_Images">トップへ行く</nuxt-link>
    <nuxt-link to="/post_images/new_post_image">新規投稿する</nuxt-link>
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";
// import axios from "axios";
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      email: "",
      password: "",
      name: "",
      profile_name: ""
    };
  },
  methods: {
    hundleSubmit() {
      this.$store.dispatch("signUp", [
        this.email,
        this.password,
        this.name,
        this.profile_name
      ]);
      //   .then(() => {
      //   const end_user = {
      //       email: this.email,
      //       name: this.name,
      //       profile_name: this.profile_name
      //   };
      //   axios.post("/end_users", {
      //       end_user
      //     //   email: end_user.email,
      //     //   name: end_user.name,
      //     //   profile_name: end_user.profile_name
      //   });
      this.email = "";
      this.password = "";
      this.name = "";
      this.profile_name = "";
      //   });
    },
    googleLogIn() {
      this.$store.dispatch("logInGoogle");
    },
    logOut() {
      this.$store.dispatch("logOut");
    }
  }
};
</script>

<style>
</style>