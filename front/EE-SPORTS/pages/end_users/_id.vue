<template>
  <div>
    <h1>{{ this.end_user.email }}</h1>
    <h2>{{ this.end_user.name }}</h2>
    <h2>{{ this.end_user.profile_name}}</h2>
    <nuxt-link :to="`/end_users/${this.end_user.id}/edit`">プロフィール編集</nuxt-link>
    <img :src="`http://localhost:3001/end_users/${this.end_user.profile_image_name}`" alt />

    <template v-if="!end_user.isFol">
      <v-btn @click="createFollow(end_user)">フォロー</v-btn>
    </template>
    <template v-else>
      <v-btn @click="destroyFollow(end_user)">フォローをやめる</v-btn>
    </template>
    <v-btn @click="destroyFollow(end_user)">フォローをやめる</v-btn>
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
  async created() {
    const res = await axios.get(`/end_users/${this.$route.params.id}`);
    this.end_user = res.data;
    // console.log(res.data);
    const following = {
      end_user_id: this.user.id
    };
    // this.戻り値を代入する変数を定義する
    // this.followers = res.data.passive_relationships.map(follower => {
    //   follower.isFol = follower.passive_relationships.some(
    //     fol => fol.followed_id === following.end_user_id
    //   );
    //   return follower;
    // });
    // debugger;

    // console.log(this.follower);
    // const follow = {
    //   res.data. this
    // };
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
        console.log(this.end_user);
        console.log("--------------");
        console.log(this.user);
        await axios.post(`/end_users/${this.end_user.id}/relationships`, vm);
        end_user.isFol = true;
      } catch (err) {
        alert(err);
      }
    },
    async destroyFollow(end_user) {
      let vm = this;
      const ps = vm.end_user.followers.map(fol => {
        if (fol.id === vm.user.id) {
          return fol;
        }
      });
      console.log({ ps });
      try {
        await axios.delete(
          `/end_users/${this.end_user.id}/relationships/${ps[0].id}`
        );
      } catch (err) {
        alert(err);
      }
    }
  }
};
</script>

<style>
</style>