<template>
  <div>
    <v-card class="mx-auto" max-width="600" tile>
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

        <v-col>
          <v-list-item color="rgba(0, 0, 0, .4)" dark>
            <v-list-item-content>
              <v-list-item-title class="title">{{ end_user.name }}</v-list-item-title>
              <v-list-item-subtitle>{{ end_user.profile_name}}</v-list-item-subtitle>
              <v-list-item-subtitle>{{ end_user.email}}</v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </v-col>

        <!-- NOTE:フォロー -->
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
                <nuxt-link :to="`/end_users/${this.end_user.id}/edit`">プロフィール編集</nuxt-link>
              </v-list-item-subtitle>

              <v-list-item-subtitle>
                <nuxt-link :to="`/end_users/${this.end_user.id}/followers`">フォロワーリスト</nuxt-link>
              </v-list-item-subtitle>

              <v-list-item-subtitle>
                <nuxt-link :to="`/end_users/${this.end_user.id}/follows`">フォローリスト</nuxt-link>
              </v-list-item-subtitle>

              <!-- NOTE:仮のルーム作成ボタン -->
              <v-list-item-subtitle>
                <button v-if="roomExist === false" @click="chatRoomCreate">メッセージ</button>
                <button v-else>
                  <nuxt-link
                    :to="`/end_users/${this.$route.params.id}/chat/${this.currentUser.id}`"
                  >メッセージ</nuxt-link>
                </button>
              </v-list-item-subtitle>
            </v-list-item-content>
          </v-list-item>
        </v-col>
      </v-row>
    </v-card>

    <!-- NOTE:サムネイル表示 -->
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
import firebase from "@/plugins/firebase";

const db = firebase.firestore();

export default {
  data() {
    return {
      baseUrl: process.env.BASE_URL,
      end_user: {},
      followers: [],
      follower: "",
      follow_list: [],
      isFol: false,

      // TODO:overlayを使用したモーダルを表示しないのなら削除する
      overlay: false,
      roomExist: false
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    }
  },
  middleware: "authenticated",

  async created() {
    // console.log("aaa");
    await this.updateFollowers();
    await this.$store.dispatch("notificationsCheck", this.$store.state.user);
  },

  // currentUserがend_userのpassive_relationshipのfollowingsにいるかどうか
  methods: {
    async updateFollowers() {
      // console.log("bbbb");
      let para = `${this.$route.params.id}`;
      let url = "/end_users/" + para;
      const res = await axios.get(url);
      this.end_user = res.data; //チェックされてるユーザー
      // console.log("res.data", res.data);
      const vm = this.end_user;
      const following = {
        //ここが怪しい...
        end_user_id: vm.id //follower
      };
      // console.log("cccc");
      this.followers = res.data.passive_relationships.map(follower => {
        // console.log("dddd");
        // console.log("follower", follower);
        // console.log("this.currentUser", this.currentUser);
        // console.log("follower.following_id", follower.following_id);
        // console.log(
        //   "follower.following_id === this.currentUser.id",
        //   follower.following_id === this.currentUser.id
        // );
        // follower.following_id === vm.id && //follower.folllowing.idはcurrentUser.idと等しいかどうかcheckされる
        if (
          follower.following_id === this.currentUser.id &&
          follower.follower_id === parseInt(`${this.end_user.id}`)
        ) {
          //res.dataの情報をthis.end_userに代入している
          // console.log(
          //   "follower.follower_id === parseInt(`${this.end_user.id}`",
          //   follower.follower_id === parseInt(`${this.end_user.id}`)
          // );
          this.isFol = true;
        }
        return follower;
      });
      let room = db
        .collection("users")
        .doc(`${this.currentUser.id}` + `${this.end_user.id}`);
      console.log("room", room);
      console.log(
        "`${this.currentUser.id}` + `${this.end_user.id}`",
        `${this.currentUser.id}` + `${this.end_user.id}`
      );
      if (room) {
        this.roomExist = true;
      }
    },
    // FIXME:isFolを与える部分がおかしくなってる
    // TODO:createFollowのthis.updateFollowers()の後のisFOLの記述が必要かどうか確かめる。
    async createFollow(end_user) {
      const vm = { id: this.currentUser.id };
      try {
        await axios.post(`/end_users/${this.end_user.id}/relationships`, vm);
        await this.updateFollowers();
        this.followers = this.followers.map(follower => {
          follower.isFol =
            follower.following_id === vm.id &&
            follower.follower_id === parseInt(`${this.end_user.id}`);
          this.isFol = true;
          return follower;
        });
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
        );
        await this.updateFollowers();
        this.isFol = false;
      } catch (err) {
        alert(err);
      }
    },
    // NOTE:chatルーム作成
    chatRoomCreate() {
      // console.log("typeof this.end_user.id", typeof this.end_user.id);
      // console.log("typeof this.currentUser.id", typeof this.currentUser.id);
      db.collection("users")
        .doc(`${this.currentUser.id}` + `${this.end_user.id}`)
        .set({
          user_id: this.end_user.id,
          current_user_id: this.currentUser.id
        });
      this.updateFollowers();
    }
  }
};
</script>

<style>
</style>