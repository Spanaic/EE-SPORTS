<template>
  <div>
    <h1>{{ this.end_user.email }}</h1>
    <h2>{{ this.end_user.name }}</h2>
    <h2>{{ this.end_user.profile_name}}</h2>
    <nuxt-link :to="`/end_users/${this.end_user.id}/edit`">プロフィール編集</nuxt-link>
    <img :src="`http://localhost:3001/end_users/${this.end_user.profile_image_name}`" alt />

    <!-- <div v-for="(follower,i) in followers" :key="i"> -->
    <template v-if="!this.end_user.isFol">
      <v-btn @click="createFollow(end_user)">フォロー</v-btn>
    </template>
    <template v-else>
      <v-btn @click="destroyFollow(end_user)">フォローをやめる</v-btn>
    </template>
    <!-- </div> -->
    <!-- <v-btn @click="destroyFollow(end_user)">フォローをやめる</v-btn> -->
  </div>
</template>
<script>
import axios from "@/plugins/axios";
import vuex from "vuex";

export default {
  data() {
    return {
      end_user: {},
      followers: {},
      folower: "",
      follow_list: []
    };
  },
  computed: {
    user() {
      return this.$store.state.user;
    }
  },
  async mounted() {
    const res = await axios.get(`/end_users/${this.$route.params.id}`);
    this.end_user = res.data;
    console.log("--------------");
    console.log(this.end_user.passive_relationships[0].isFol);
    console.log("--------------");
    const vm = this.end_user;
    const following = {
      // end_user_idは空っぽでok, this.user.idを代入してる。
      end_user_id: vm.id
      // end_user_id: this.user.id
    };
    // debugger;
    console.log(this);
    this.followers = res.data.passive_relationships.map(follower => {
      follower.isFol =
        follower.following_id === following.end_user_id ? true : false;
      // .includes(following.end_user_id);
      // console.log(follower.isFol);
      return follower;
      debugger;
      // return (follower = this.follower);
      const currentfollower = followers.followings.includes(
        following.end_user_id
      );
      // includesはtrue/falseで返す
      console.log(this.followers);
    });
    // this.followers = res.data.passive_relationships.map(follower => {
    //   follower.isFol =
    //     follower.following_id === following.end_user_id ? true : false;
    //   // .includes(following.end_user_id);
    //   console.log(follower.isFol);
    //   debugger;
    //   return follower;
    //   console.log(follower);
    // });
  },

  methods: {
    async createFollow(end_user) {
      const vm = { id: this.user.id };
      console.log(vm);
      try {
        // let vm = this.follow_list.push(`${this.end_user}, ${this.user}`);
        // vm.push(this.user);
        console.log("--------------");
        // console.log(vm[0]);
        console.log("--------------");
        console.log(this.end_user.passive_relationships);
        console.log("--------------");
        console.log(this.end_user.passive_relationships.following_id);
        console.log("--------------");
        console.log(this.user.id);
        await axios.post(`/end_users/${this.end_user.id}/relationships`, vm);
        follower.isFol = true;
      } catch (err) {
        alert(err);
      }
    },
    async destroyFollow(end_user) {
      let vm = this;
      const ps = end_user.passive_relationships.map(fol => {
        if (fol.following_id === vm.user.id) {
          return fol;
          console.log(fol);
        }
      });
      console.log("--------------");
      console.log({ ps });
      try {
        await axios.delete(
          `/end_users/${this.end_user.id}/relationships/${ps[0].id}`
          // `/end_users/${this.end_user.id}/relationships/${ps[0].follower_id}`
        );
        follower.isFol = false;
      } catch (err) {
        alert(err);
      }
    }
  }
};
</script>

<style>
</style>