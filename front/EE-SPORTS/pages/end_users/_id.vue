<template>
  <div>
    <v-card class="mx-auto" max-width="600" tile>
      <!-- <v-img height="100%" src="http://localhost:3001/gamer-background-2.png"> -->
      <v-row align="end" class="fill-height">
        <v-col align-self="start" class="pa-0" cols="3">
          <v-avatar class="profile" color="grey" size="164" tile>
            <v-img
              v-if="end_user.profile_image_name"
              :src="`${baseUrl}/end_users/${end_user.profile_image_name}`"
            ></v-img>
            <v-img v-else :src="`${baseUrl}/no_image.jpg`"></v-img>
          </v-avatar>
        </v-col>

        <!-- <v-row class="py-0"> -->
        <v-col>
          <v-list-item color="rgba(0, 0, 0, .4)" dark>
            <v-list-item-content>
              <v-list-item-title class="title">{{ end_user.name }}</v-list-item-title>
              <v-list-item-subtitle>{{ end_user.profile_name}}</v-list-item-subtitle>
              <v-list-item-subtitle>{{ end_user.email}}</v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </v-col>

        <v-col>
          <v-list-item color="rgba(0, 0, 0, .4)" dark>
            <v-list-item-content>
              <v-list-item-title class="title">
                <div v-if="this.currentUser.id !== end_user.id">
                  <template v-if="!this.isFol">
                    <v-btn @click="createFollow(end_user)">フォロー</v-btn>
                  </template>
                  <template v-else>
                    <v-btn @click="destroyFollow(end_user)">フォローをやめる</v-btn>
                  </template>
                </div>
              </v-list-item-title>

              <v-list-item-subtitle v-if="currentUser.id === end_user.id">
                <!-- <v-list-item-subtitle> -->
                <nuxt-link :to="`/end_users/${this.end_user.id}/edit`">プロフィール編集</nuxt-link>
              </v-list-item-subtitle>

              <v-list-item-subtitle>
                <nuxt-link :to="`/end_users/${this.end_user.id}/followers`">フォロワーリスト</nuxt-link>
              </v-list-item-subtitle>

              <v-list-item-subtitle>
                <nuxt-link :to="`/end_users/${this.end_user.id}/follows`">フォローリスト</nuxt-link>
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </v-col>
      </v-row>
      <!-- </v-row> -->
      <!-- </v-img> -->
    </v-card>

    <!-- <div v-for="(post_image, i) in this.end_user.post_images" :key="i">
      <v-toolbar color="indigo" dark>
        <v-list-item>
          <v-list-item-avatar>
            <v-img :src="'http://localhost:3001/end_users/' + `${post_image.profile_image_name}`"></v-img>
          </v-list-item-avatar>
          <v-list-item-content>
            <v-list-item-title class="headline">{{ post_image.title }}</v-list-item-title>
          </v-list-item-content>
        </v-list-item>
      </v-toolbar>

      <v-card class="mx-auto mb-5" height="100%" max-width="800">
        <v-img
          class="white--text align-end"
          height="400px"
          :src="'http://localhost:3001/post_images/' + post_image.image_name"
          @click="overlay =!overlay"
        >
          <v-card-title>Top 10 Australian beaches</v-card-title>
        </v-img>
        <v-overlay :value="overlay">
          <v-btn icon @click="overlay = false">
            <v-icon>mdi-close</v-icon>
            <nuxt-link :to="`/post_images/${ post_image.id }`">
              <v-img
                class="white--text align-end"
                height="480px"
                width="720px"
                :src="'http://localhost:3001/post_images/' + post_image.image_name"
              ></v-img>
            </nuxt-link>
          </v-btn>
        </v-overlay>

        <v-card-subtitle class="pb-0">Number 10</v-card-subtitle>

        <v-card-text class="text--primary">
          <div v-for="(hashtag, i) in post_image.hashtags" :key="i">
            <nuxt-link :to="`/post_Images/hashtag/${hashtag.hashname}`">
              <v-chip class="ma-2" color="secondary">{{ hashtag.hashname }}</v-chip>
            </nuxt-link>
          </div>
          <div>{{post_image.caption}}</div>

          <div>Whitsunday Island, Whitsunday Islands</div>
        </v-card-text>
        <v-card-text
          class="text--primary"
          v-for="(post_comment, i) in post_image.post_comments"
          :key="i"
        >
          <div>{{post_comment.comment}}</div>
        </v-card-text>

        <v-card-actions>
          <v-btn color="orange" text>Share</v-btn>

          <v-btn color="orange" text>Explore</v-btn>

          <template v-if="!post_image.isFav">
            <v-btn icon @click="createFavorite(post_image)">
              <v-icon>mdi-thumb-up-outline</v-icon>
            </v-btn>
          </template>
          <template v-else>
            <v-btn text icon color="deep-orange" @click="destroyFavorite(post_image)">
              <v-icon>mdi-thumb-up</v-icon>
            </v-btn>
          </template>

          <v-row justify="center">
            <v-dialog v-model="dialog" persistent max-width="600px">
              <template v-slot:activator="{ on }">
                <v-btn color="primary" dark v-on="on" @click="setPostImage(post_image); ">コメントする</v-btn>
              </template>
              <v-card>
                <v-card-title>
                  <span class="headline">コメント入力フォーム</span>
                </v-card-title>
                <v-card-text>
                  <v-container>
                    <v-row>
                      <v-col cols="12" sm="6" md="4" lg="12">
                        <v-text-field label="Outlined" outlined v-model="post_comment"></v-text-field>
                      </v-col>
                    </v-row>
                  </v-container>
                  <small>*indicates required field</small>
                </v-card-text>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" text @click="dialog = false">Close</v-btn>
                  <v-btn color="blue darken-1" text @click="saveComment()">Save</v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-row>
        </v-card-actions>

        <v-col cols="12" lg="12" sm="6" md="3"></v-col>
      </v-card>
    </div>-->

    <!-- サムネイル表示 -->
    <v-row>
      <v-col cols="12" sm="6" offset-sm="3">
        <v-card>
          <v-container fluid>
            <v-row>
              <v-col
                v-for="(post_image, i) in end_user.post_images"
                :key="i"
                class="d-flex child-flex"
                cols="4"
              >
                <nuxt-link :to="`/post_Images/${post_image.id}`">
                  <v-card flat tile class="d-flex">
                    <v-img
                      :src="`${baseUrl}/post_images/${post_image.image_name}`"
                      :lazy-src="`${baseUrl}/post_images/${post_image.image_name}`"
                      aspect-ratio="1"
                      class="grey lighten-2"
                    >
                      <template v-slot:placeholder>
                        <v-row class="fill-height ma-0" align="center" justify="center">
                          <v-progress-circular indeterminate color="grey lighten-5"></v-progress-circular>
                        </v-row>
                      </template>
                    </v-img>
                  </v-card>
                </nuxt-link>
              </v-col>
            </v-row>
          </v-container>
        </v-card>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import Vuex from "vuex";

export default {
  data() {
    return {
      baseUrl: process.env.baseUrl,
      end_user: {},
      followers: [],
      follower: "",
      follow_list: [],
      isFol: false,

      overlay: false
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    }
  },
  middleware: "authenticated",
  async mounted() {
    await this.updateFollowers();
    await this.$store.dispatch("notificationsCheck", this.$store.state.user);
    // let para = `${this.$route.params.id}`;
    // console.log(para);
    // let url = "/end_users/" + para;
    // console.log(url);

    // console.log(this);

    // const res = await axios.get(url);
    // this.end_user = res.data;
    // console.log("--------------");
    // // console.log(this.end_user.passive_relationships[0].isFol);
    // console.log("--------------");
    // const vm = this.end_user;
    // // console.log(vm);
    // const following = {
    //   // end_user_idは空っぽでok, this.user.idを代入してる。
    //   end_user_id: vm.id
    //   // end_user_id: this.user.id
    // };
    // console.log(this);
    // // debugger;
    // // console.log(this);
    // this.followers = res.data.passive_relationships.map(follower => {
    //   // follower.isFol = follower.following_id === following.end_user_id;
    //   // .includes(following.end_user_id);
    //   debugger;
    //   // follower.isFol =
    //   follower.following_id === vm.id &&
    //     follower.follower_id === parseInt(`${this.end_user.id}`);
    //   this.isFol = true;
    //   console.log(follower.isFol);
    //   return follower;
    // });
    // // return (follower = this.follower);
    // // const currentfollower = this.followers.followings.includes(
    // //   following.end_user_id
    // // );
    // // includesはtrue/falseで返す
    // console.log(this.followers);
    // // this.followers = res.data.passive_relationships.map(follower => {
    // //   follower.isFol =
    // //     follower.following_id === following.end_user_id ? true : false;
    // //   // .includes(following.end_user_id);
    // //   console.log(follower.isFol);
    // //   debugger;
    // //   return follower;
    // //   console.log(follower);
    // // });
  },

  methods: {
    async updateFollowers() {
      let para = `${this.$route.params.id}`;
      let url = "/end_users/" + para;
      const res = await axios.get(url);
      this.end_user = res.data;
      const vm = this.end_user;
      const following = {
        end_user_id: vm.id
      };
      this.followers = res.data.passive_relationships.map(follower => {
        follower.following_id === vm.id &&
          follower.follower_id === parseInt(`${this.end_user.id}`);
        this.isFol = true;
        return follower;
      });
    },
    async createFollow(end_user) {
      const vm = { id: this.currentUser.id };
      try {
        // let vm = this.follow_list.push(`${this.end_user}, ${this.user}`);
        // vm.push(this.user);
        // console.log(vm[0]);
        // console.log(this.end_user.passive_relationships.following_id);
        await axios.post(`/end_users/${this.end_user.id}/relationships`, vm);
        await this.updateFollowers();
        this.followers = this.followers.map(follower => {
          follower.isFol =
            follower.following_id === vm.id &&
            follower.follower_id === parseInt(`${this.end_user.id}`);
          this.isFol = true;
          return follower;
        });

        //follower.isFol = true;
      } catch (err) {
        alert(err);
      }
    },
    async destroyFollow(end_user) {
      const vm = { id: this.currentUser.id };
      const ps = end_user.passive_relationships.map(fol => {
        if (fol.following_id === vm.id) {
          return fol;
        }
      });
      try {
        await axios.delete(
          `/end_users/${this.end_user.id}/relationships/${ps[0].id}`
          // `/end_users/${this.end_user.id}/relationships/${ps[0].follower_id}`
        );
        await this.updateFollowers();
        this.isFol = false;
      } catch (err) {
        alert(err);
      }
    }
    // async destroyFollow(end_user) {
    //   let vm = this;
    //   const ps = end_user.passive_relationships.map(fol => {
    //     if (fol.following_id === vm.user.id) {
    //       return fol;
    //       console.log(fol);
    //     }
    //   });
    //   console.log("--------------");
    //   console.log({ ps });
    //   try {
    //     await axios.delete(
    //       `/end_users/${this.end_user.id}/relationships/${ps[0].id}`
    //       // `/end_users/${this.end_user.id}/relationships/${ps[0].follower_id}`
    //     );
    //     this.isFol = false;
    //   } catch (err) {
    //     alert(err);
    //   }
    // }
  }
};
</script>

<style>
</style>