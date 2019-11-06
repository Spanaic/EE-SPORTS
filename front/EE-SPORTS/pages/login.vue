<template>
  <div>
    <form action @submit.prevent="hundleSubmit">
      <input type="text" v-model="email" />
      <input type="text" v-model="password" />
      <input type="submit" />
    </form>
    <button type="button" @click="googleLogIn">Google認証</button>
    <button type="button" @click="logOut">log out</button>
    <div v-if="error_checker === true">{{error}}</div>
  </div>
</template>

<script>
import firebase from "@/plugins/firebase";
import axios from "axios";

export default {
  data() {
    return {
      email: "",
      password: "",
      error: "",
      error_checker: false
    };
  },
  mounted() {
    // console.log(firebase.auth().currentUser);
  },
  methods: {
    hundleSubmit() {
      this.$store.dispatch("logIn", [this.email, this.password]);
      //   var provider = new firebase.auth.GoogleAuthProvider();
      //   firebase.auth().signInWithPopup(provider);
      // firebase
      //   .auth()
      //   .createUserWithEmailAndPassword(this.email, this.password)
      //   .then(user => {
      //     console.log(user.user.email);
      //     axios.post("http://localhost:3001/users", {
      //       email: this.email
      //     });
      //     this.email = "";
      //     this.password = "";
      //     console.log("Sign-out successful.");
      //     this.$router.push("/");
      //   })
      //   .catch(err => {
      //     this.error = err.message;
      //     this.error_checker = true;
      //     console.log(this.error_checker);
      //   });
    },
    logOut() {
      this.$store.dispatch("logOut");
      // firebase
      //   .auth()
      //   .signOut()
      //   .then(function() {
      //     console.log("Sign-out successful.");
      //   })
      //   .catch(function(error) {
      //     console.log("An error happened.");
      //   });
    },
    googleLogIn() {
      // var provider = new firebase.auth.GoogleAuthProvider();
      // firebase
      //   .auth()
      //   .signInWithPopup(provider)
      //   .then(res => {
      //     console.log("Sign-in successful.");
      //   });
      this.$store.dispatch("logInGoogle");
    }
  }
};
</script>

<style>
</style>