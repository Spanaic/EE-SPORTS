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

              <!-- NOTE:ルーム作成ボタン or roomに移動するボタン 　※相互フォローで表示される-->
              <v-list-item-subtitle v-if="isFol === true && isActiveFol === true">
                <button v-if="roomExist === false" @click="chatRoomCreate">メッセージ</button>
                <button v-else>
                  <nuxt-link :to="`/chat/${chatId}`">メッセージ</nuxt-link>
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
      // follower: "",
      // follow_list: [],
      isFol: false, //followしているかどうか
      roomExist: false, //roomが作成されているかどうか
      chatId: "", //chatroomへ飛ばすためのdata

      // NOTE:相互フォローがあるかどうかをチェックする
      isActiveFol: false, //followされているかどうか
      followings: [],

      // TODO:overlayを使用したモーダルを表示しないのなら削除する
      overlay: false
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    }
  },
  middleware: "authenticated",

  async created() {
    await this.updateFollowers();
    await this.$store.dispatch("notificationsCheck", this.$store.state.user);
  },

  methods: {
    async updateFollowers() {
      let para = `${this.$route.params.id}`;
      let url = "/end_users/" + para;
      const res = await axios.get(url);
      this.end_user = res.data; //チェックされてるユーザー
      const vm = this.end_user;

      // NOTE:フォローしているかチェック
      const following = {
        end_user_id: vm.id //follower
      };
      this.followers = res.data.passive_relationships.map(follower => {
        if (
          follower.following_id === this.currentUser.id &&
          follower.follower_id === parseInt(`${this.end_user.id}`)
        ) {
          this.isFol = true;
        }
        return follower;
      });

      //NOTE:フォローされているかチェック
      this.followings = res.data.active_relationships.map(following => {
        if (following.follower_id === this.currentUser.id) {
          this.isActiveFol = true;
        }
        return following;
      });

      // NOTE:roomがend_userとcurrent_user間で作られているかを判定する
      let room = db
        .collection("users")
        .get()
        .then(querySnapshot => {
          querySnapshot.docs.forEach(doc => {
            let number_1 = `${this.currentUser.id}` + `${this.end_user.id}`;
            let number_2 = `${this.end_user.id}` + `${this.currentUser.id}`;
            if (doc.id === number_1 || doc.id === number_2) {
              this.roomExist = true;
              this.chatId = doc.data().chat_room_id; //フィールドとして持たせた値をdataに代入することで対応オッケ
              console.log("this.chatId", this.chatId);
              console.log("doc.data().chat_room_id", doc.data().chat_room_id);
            }
          });
        });
    },
    async createFollow(end_user) {
      const vm = { id: this.currentUser.id };
      try {
        await axios.post(`/end_users/${this.end_user.id}/relationships`, vm);
        await this.updateFollowers();
      } catch (err) {
        alert(err);
      }
    },
    // FIXME:isFolの記述が必要かどうか確認後、要らなければ削除
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
      db.collection("users")
        .doc(`${this.currentUser.id}` + `${this.end_user.id}`)
        .set({
          user_id: this.end_user.id,
          current_user_id: this.currentUser.id,
          chat_room_id: `${this.currentUser.id}` + `${this.end_user.id}`
        });
      this.chatId = `${this.currentUser.id}` + `${this.end_user.id}`;
      this.$router.push(`/chat/${this.chatId}`);
      this.updateFollowers();
    }
  }
};
</script>

<style>
</style>