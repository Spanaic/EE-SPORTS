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

              <!-- NOTE:ルーム作成ボタン or roomに移動するボタン -->
              <v-list-item-subtitle>
                <button v-if="roomExist === false" @click="chatRoomCreate">メッセージ</button>
                <button v-else>
                  <!-- TODO: to以下を変数に格納して、roomを見つけ出してから変数にidを格納する。 -->
                  <nuxt-link :to="`/chat/${chatId}`">
                    メッセージ
                    {{chatId}}
                  </nuxt-link>
                  <!-- :to="`/end_users/${this.$route.params.id}/chat/${this.currentUser.id}`" -->
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
      roomExist: false,

      // NOTE: chatroomへ飛ばすためのdata
      // chatUrl: "",
      chatId: "",

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

          // NOTE:引っ張ってきたdoc.idの内、変数と一致した値だけを引っ張ってくる。=> 失敗！
          //   querySnapshot.docs.map(doc => {
          //     let number_1 = `${this.currentUser.id}` + `${this.end_user.id}`;
          //     let number_2 = `${this.end_user.id}` + `${this.currentUser.id}`;
          //     doc.id === number_1 || number_2;
          //     return (this.chatId = doc.id.toString());
          //   });

          //   console.log("querySnapshot.docs.length", querySnapshot.docs.length);
          //   console.log("querySnapshot.docs", querySnapshot.docs);
          //   // this.chatId = querySnapshot.docs[0].id;
          //   // this.chatUrl = `/chat/${doc.id}`;
          //   console.log("this.chatId", this.chatId);
          //   console.log("typeof this.chatId", typeof this.chatId);
          // });

          // let number_1 = `${this.currentUser.id}` + `${this.end_user.id}`;
          // let number_2 = `${this.end_user.id}` + `${this.currentUser.id}`;
          // let chatRoom = db
          //   .collection("users")
          //   .where("id", "==", `${number_1}`)
          //   .get()
          //   .then(query => {
          //     console.log("query", query);
          //   });
          // let chatRoom2 = db
          //   .collection("users")
          //   .where("id", "==", `${number_2}`)
          //   .get()
          //   .then(query2 => {
          //     console.log("query2", query2);
          //   });
          // let chatRoom3 = db
          //   .collection("users")
          //   .where("id", "==", "32")
          //   .get()
          //   .then(query3 => {
          //     console.log("query3", query3);
          //   });
          // let chatRoom4 = db
          //   .collection("users")
          //   .get()
          //   .then(query4 => {
          //     console.log("query4", query4);
          //   });

          // NOTE:なんとかwhereでdocArrayを引っ張ってこれないか試している =>　失敗！
          let number_1 = `${this.currentUser.id}` + `${this.end_user.id}`;
          let number_2 = `${this.end_user.id}` + `${this.currentUser.id}`;

          var docRef = db.collection("users").doc(number_1);
          var docRef2 = db.collection("users").doc(number_2);

          console.log("docRef", docRef.id);
          console.log("docRef2", docRef2.id);
          console.log("number_1", number_1);

          let docRef3 = db
            .collection("users")
            .where("chat_room_id", "==", number_1)
            .get()
            .then(res => {
              console.log("res", res);
            });
          console.log("docRef3", docRef3);

          let docRef4 = db
            .collection("users")
            .where("chat_room_id", "==", number_2)
            .get()
            .then(res => {
              console.log("res2", res);
            });
          console.log("docRef4", docRef4);

          // .get()
          // .then(doc => {
          //   if (doc.exits) {
          //     console.log("docRef3", doc);
          //   }
          // });

          docRef
            .get()
            .then(doc => {
              if (doc.exists) {
                console.log("doc.data()", doc.data());
              } else {
                console.log("404");
              }
            })
            .catch(error => {
              console.log(`データを取得できませんでした (${error})`);
            });
          docRef2
            .get()
            .then(doc => {
              if (doc.exists) {
                console.log("doc.data()2", doc.data());
              } else {
                console.log("404");
              }
            })
            .catch(error => {
              console.log(`データを取得できませんでした (${error})`);
            });

          // console.log("chatRoom", chatRoom);
          // console.log("chatRoom2", chatRoom2);
        });
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