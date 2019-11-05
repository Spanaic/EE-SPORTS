<template>
  <div>
    <form @submit.prevent="unko">
      <input type="text" v-model="email" />
      <input type="text" v-model="password" />
      <input type="submit" />
    </form>
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";
export default {
  data() {
    return {
      email: "",
      password: ""
    };
  },
  mounted() {
    console.log(firebase.auth().currentUser);
  },
  methods: {
    unko() {
      var provider = new firebase.auth.GoogleAuthProvider();
      firebase.auth().signInWithPopup(provider);
      //   firebase
      //     .auth()
      //     .createUserWithEmailAndPassword(this.email, this.password)
      //     .then(() => {
      //       (this.email = ""), (this.password = "");
      //     });

      //   this.$router.push("/");
    }
  }
};
</script>

<style>
</style>