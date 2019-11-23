<template>
  <div>
    <!-- <img v-bind:src="'http://localhost:3001/post_images/' + post_image.image_name" /> -->

    <div>
      <!-- <div
        v-for="(post_image, i) in $store.state.search.length ?  $store.state.search : filterdPostImages"
        :key="i"
      >-->
      <v-card class="mx-auto mb-5" height="100%" max-width="800">
        <v-img
          class="white--text align-end"
          height="400px"
          :src="'http://localhost:3001/post_images/' + post_image.image_name"
          @click="overlay =!overlay"
        >
          <v-card-title></v-card-title>
        </v-img>

        <v-card-title>
          <!-- <v-btn dark icon>
            <v-icon>mdi-chevron-left</v-icon>
          </v-btn>-->

          <v-spacer></v-spacer>

          <!-- <v-btn dark icon class="mr-4">
            <v-icon>mdi-pencil</v-icon>
          </v-btn>-->

          <v-btn dark icon>
            <v-icon>mdi-dots-vertical</v-icon>
          </v-btn>
        </v-card-title>

        <v-overlay :absolute="absolute" :value="overlay">
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

        <!-- <v-toolbar color="indigo" dark>
          <nuxt-link :to="`/end_users/${post_image.end_user.id}`">
            <v-list-item>
              <v-list-item-avatar>
                <v-img
                  :src="'http://localhost:3001/end_users/' + post_image.end_user.profile_image_name"
                ></v-img>
              </v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title class="headline">{{ post_image.title }}</v-list-item-title>
                <v-list-item-subtitle>by {{ post_image.end_user.profile_name }}</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </nuxt-link>
        </v-toolbar>-->

        <v-card-subtitle class="pb-0"></v-card-subtitle>

        <v-card-text class="text--primary">
          <v-item-group multiple>
            <v-subheader>ハッシュタグ</v-subheader>
            <v-item
              v-for="(hashtag, i) in post_image.hashtags"
              :key="i"
              v-slot:default="{ active, toggle }"
            >
              <nuxt-link :to="`/post_Images/hashtag/${hashtag.hashname}`">
                <v-chip
                  class="ma-1"
                  active-class="purple--text"
                  :input-value="active"
                  @click="toggle"
                  color="teal"
                >{{ hashtag.hashname }}</v-chip>
              </nuxt-link>
            </v-item>

            <v-divider class="my-4 info" style="opacity: 0.22"></v-divider>
          </v-item-group>
          <v-subheader>説明</v-subheader>
          <div>{{post_image.caption}}</div>
          <v-divider class="my-4 info" style="opacity: 0.22"></v-divider>
        </v-card-text>
        <v-subheader>コメント</v-subheader>
        <v-card-text
          class="text--primary"
          v-for="(post_comment, i) in post_image.post_comments"
          :key="i"
        >
          <div align="center">{{post_comment.comment}}</div>
        </v-card-text>

        <v-card-actions>
          <v-btn color="orange" text></v-btn>

          <v-btn color="orange" text></v-btn>

          <!-- お気に入り機能ボタンボタン（作りかけ） -->
          <template v-if="post_image.isFav !== true || undefined">
            <!-- <div>{{post_image.id}}</div> -->
            <v-btn icon @click="createFavorite(post_image)">
              <!-- <v-icon>mdi-heart-outline</v-icon> -->
              <v-icon>mdi-thumb-up-outline</v-icon>
            </v-btn>
          </template>
          <template v-else>
            <!-- <v-btn icon @click="destroyFavorite(post_image)">
                        <v-icon>mdi-heart</v-icon>
            </v-btn>-->
            <v-btn text icon color="deep-orange" @click="destroyFavorite(post_image)">
              <v-icon>mdi-thumb-up</v-icon>
            </v-btn>
          </template>

          <!-- <comment-form></comment-form> -->
          <!-- コメント入力のダイアログ -->
          <v-row justify="center">
            <v-dialog v-model="dialog" persistent max-width="600px">
              <template v-slot:activator="{ on }">
                <!-- <div>{{post_image.id}}</div> -->
                <!-- {{i}} -->
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
                  <!-- <small>"#"を付ければハッシュタグも入力出来るよ！</small> -->
                  <medium>とてもポジティブなコメントで応援してあげよう！</medium>
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

        <v-col cols="12" lg="12" sm="6" md="3">
          <!-- <v-text-field label="Outlined" outlined></v-text-field> -->
        </v-col>
      </v-card>
    </div>
  </div>
  <!-- </div> -->
</template>

<script>
import axios from "@/plugins/axios";
import { mdiPound } from "@mdi/js";
import { mdiPoundBoxOutline } from "@mdi/js";
import { mdiThumbUp } from "@mdi/js";
import { mdiThumbUpOutline } from "@mdi/js";
import firebase from "@/plugins/firebase";

const url = "http://localhost:3001/post_images";

export default {
  data() {
    return {
      post_image: {},
      current_user: [],
      dialog: false,
      post_comments: [],
      post_comment: "",
      favoriteCheck: false,
      favorite_list: [],
      absolute: true,
      overlay: false,
      isActive: false
    };
  },
  async created() {
    const unwatch = this.$store.watch(
      state => state.user,
      async (newUser, oldUser) => {
        console.log("state2", newUser);
        if (newUser.id) {
          try {
            const res = await axios.get(url + `/${this.$route.params.id}`);
            let current_user_id = this.user.id;
            console.log("current_user_id", current_user_id);
            console.log("res.data", res.data);
            console.log("post_image.end_user.id", res.data.end_user.id);

            this.post_image = res.data;
            this.post_image.favorites.forEach(fav => {
              if (fav.end_user_id === current_user_id) {
                return (res.data.isFav = true);
              } else {
                return (res.data.isFav = false);
              }
            });
            this.post_image.caption.replace(
              /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
              ""
            );
            console.log("this.post_image.caption", this.post_image.caption);
            this.post_image.hashtags.map(hashtag => {
              hashtag.hashname.replace(/[#＃]/gm, "");
            });
            console.log("this.post_image.hashtags", this.post_image.hashtags);
          } catch (err) {
            console.log("err", err);
          }
        }
      }
    );

    //         // this.post_images = res.data.map(post_image => {
    //         //   console.log("post_image.favorites", post_image.favorites);
    //         this.post_image = res.data.favorites.forEach(fav => {
    //           if (fav.end_user_id === current_user_id) {
    //             return (res.data.isFav = true);
    //           } else {
    //             return (res.data.isFav = false);
    //           }
    //         });
    //         this.post_image = res.data.caption.replace(
    //           /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
    //           ""
    //         );
    //         res.data.hashtags.map(hashtag => {
    //           hashtag.hashname.replace(/[#＃]/gm, "");
    //           // debugger;
    //         });
    //         return res.data;
    //         console.log("fav_post_image", post_image);
    //       } catch (err) {
    //         console.log("err", err);
    //       }
    //     }
    //   }
    // );
  },
  async mounted() {
    console.log("notificationsCheck", this.$store.state.user);
    await this.$store.dispatch("notificationsCheck", this.$store.state.user);
  },
  computed: {
    user() {
      return this.$store.state.user;
    }
  },
  methods: {
    setPostImage(postImage) {
      this.post_image = postImage;
    },

    async updatePostImages() {
      const res = await axios.get(url + `/${this.$route.params.id}`);
      console.log(res.data);
      const favorite = {
        end_user_id: this.user.id
      };
      this.post_image = res.data;
      this.post_image.isFav = this.post_image.favorites.some(
        fav => fav.end_user_id === favorite.end_user_id
      );
      this.post_image.caption.replace(
        /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
        ""
      );
      this.post_image.hashtags.map(hashtag => {
        hashtag.hashname.replace(/[#＃]/gm, "");
      });
    },
    // this.post_images = res.data.map(post_image => {
    //   post_image.isFav = post_image.favorites.some(
    //     fav => fav.end_user_id === favorite.end_user_id
    //   );
    //   post_image.caption = post_image.caption.replace(
    //     /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
    //     ""
    //   );
    //   post_image.hashtags.map(hashtag => {
    //     hashtag.hashname.replace(/[#＃]/gm, "");
    //   });
    //   return post_image;
    // });
    async saveComment() {
      console.log("-----------------------");
      console.log("id:" + this.post_image.id);
      try {
        this.dialog = false;
        console.log(this);
        const comment = {
          comment: this.post_comment,
          end_user: this.user
        };

        const { data } = await axios.post(
          `/post_images/${this.post_image.id}/post_comments`,
          comment
        );
        console.log({ data });
        this.post_image.post_comments = data;
        this.post_comment = "";
      } catch (error) {
        alert(error);
      }

      // .then(res => {
      //   this.post_comment = res.data.post_comment;
      // });
    },
    async createFavorite(post_image) {
      try {
        let vm = {
          post_image_id: post_image.id,
          end_user_id: this.user.id
        };
        console.log("favorite_vm", vm);
        await axios.post(`/post_images/${post_image.id}/favorites`, vm);
        await this.updatePostImages();
        post_image.isFav = true;
        console.log("post_image.isFav", post_image.isFav);
      } catch (error) {
        alert(error);
      }
    },
    async destroyFavorite(post_image) {
      let that = this;
      // debugger;
      const ps = post_image.favorites.map(fav => {
        if (fav.end_user_id === that.user.id) {
          return fav;
        }
      });
      console.log({ ps });
      try {
        // let byeFav = ps.slice(-1)[0];
        // let byeFav = ps[ps.length - 1];
        let byeFav = ps.filter(Boolean);
        // debugger;
        console.log("byeFav", byeFav);
        await axios.delete(
          `/post_images/${post_image.id}/favorites/${byeFav[0].id}`
        );
        this.updatePostImages();
        post_image.isFav = false;
      } catch (error) {
        alert(error);
      }
    }
  },
  async fetch({ store }) {
    await store.dispatch("authCheck");
  }
};
</script>

<style>
a {
  text-decoration: none;
}
</style>