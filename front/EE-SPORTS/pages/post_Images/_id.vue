<template>
  <div>
    <div>
      <v-card class="mx-auto mb-5" height="100%" max-width="800">
        <v-toolbar color="indigo" dark>
          <nuxt-link :to="`/end_users/${post_image.end_user.id}`">
            <v-list-item>
              <v-list-item-avatar>
                <v-img :src="`${baseUrl}/end_users/${post_image.end_user.profile_image_name}`"></v-img>
              </v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title class="headline">{{ post_image.title }}</v-list-item-title>
                <v-list-item-subtitle>by {{ post_image.end_user.profile_name }}</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </nuxt-link>
        </v-toolbar>

        <v-img
          class="white--text align-end"
          height="400px"
          :src="`${baseUrl}/post_images/${post_image.image_name}`"
          @click="overlay =!overlay"
        >
          <v-card-title></v-card-title>
        </v-img>

        <v-card-title>
          <v-spacer></v-spacer>

          <v-menu offset-y>
            <template v-slot:activator="{ on }">
              <v-btn v-on="on" dark icon v-if="$store.state.user.id === post_image.end_user_id">
                <v-icon>mdi-dots-vertical</v-icon>
              </v-btn>
            </template>

            <v-list>
              <v-list-item @click="deletePostImage(post_image)">
                <v-list-item-title>削除</v-list-item-title>
              </v-list-item>
            </v-list>
          </v-menu>
        </v-card-title>

        <v-overlay :absolute="absolute" :value="overlay">
          <v-btn icon @click="overlay = false">
            <v-icon>mdi-close</v-icon>
            <nuxt-link :to="`/post_images/${ post_image.id }`">
              <v-img
                class="white--text align-end"
                height="480px"
                width="720px"
                :src="`${baseUrl}/post_images/${post_image.image_name}`"
              ></v-img>
            </nuxt-link>
          </v-btn>
        </v-overlay>

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

        <v-card-actions>
          <v-btn color="orange" text></v-btn>

          <v-btn color="orange" text></v-btn>

          <!-- お気に入り機能ボタン -->
          <template v-if="user.id !== 0">
            <template v-if="post_image.isFav !== true || undefined">
              <v-btn icon @click="createFavorite(post_image)">
                <v-icon>mdi-thumb-up-outline</v-icon>
              </v-btn>
            </template>
            <template v-else>
              <v-btn text icon color="deep-orange" @click="destroyFavorite(post_image)">
                <v-icon>mdi-thumb-up</v-icon>
              </v-btn>
            </template>

            <!-- コメント入力のダイアログ -->
            <v-row justify="center">
              <v-dialog v-model="dialog" persistent max-width="600px">
                <template v-slot:activator="{ on }">
                  <!-- コメント入力ボタン -->
                  <v-btn
                    v-if="user"
                    color="primary"
                    dark
                    v-on="on"
                    @click="setPostImage(post_image); "
                  >コメントする</v-btn>
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
          </template>
        </v-card-actions>

        <v-container fluid>
          <v-row justify="center">
            <v-subheader>コメント</v-subheader>

            <v-expansion-panels popout>
              <v-expansion-panel
                v-for="(message, i) in post_image.post_comments"
                :key="i"
                hide-actions
              >
                <v-expansion-panel-header>
                  <v-row align="center" class="spacer" no-gutters>
                    <v-col cols="4" sm="2" md="1">
                      <v-avatar size="36px">
                        <img
                          v-if="message.end_user.profile_image_name"
                          alt="Avatar"
                          :src="`${baseUrl}/end_users/${message.end_user.profile_image_name}`"
                        />
                        <img v-else alt="Avatar" :src="`${baseUrl}/no_image.jpg`" />
                      </v-avatar>
                    </v-col>

                    <v-col class="hidden-xs-only" sm="5" md="3">
                      <strong v-html="message.end_user.profile_name"></strong>
                      <span v-if="message.total" class="grey--text">&nbsp;({{ message.total }})</span>
                    </v-col>

                    <v-col class="text-no-wrap" cols="5" sm="3">
                      <v-chip
                        v-if="message.new"
                        :color="`${message.color} lighten-4`"
                        class="ml-0"
                        label
                        small
                      >{{ message.new }} new</v-chip>
                      {{message.comment | commentsLength}}
                    </v-col>

                    <v-col
                      v-if="message.excerpt"
                      class="grey--text text-truncate hidden-sm-and-down"
                    >
                      &mdash;
                      {{ message }}
                    </v-col>
                  </v-row>
                </v-expansion-panel-header>

                <v-expansion-panel-content>
                  <v-divider></v-divider>
                  <v-card-text v-text="message.comment "></v-card-text>
                </v-expansion-panel-content>
              </v-expansion-panel>
            </v-expansion-panels>
          </v-row>
        </v-container>

        <v-col cols="12" lg="12" sm="6" md="3"></v-col>
      </v-card>
    </div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import { mdiPound } from "@mdi/js";
import { mdiPoundBoxOutline } from "@mdi/js";
import { mdiThumbUp } from "@mdi/js";
import { mdiThumbUpOutline } from "@mdi/js";
import firebase from "@/plugins/firebase";

export default {
  data() {
    return {
      baseUrl: process.env.BASE_URL,
      post_image: {},
      raw_post_image: {},
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
  filters: {
    commentsLength(comment) {
      return comment.length >= 10 ? comment.slice(0, 10) + "....." : comment;
    }
  },
  async created() {
    this.post_image = this.raw_post_image;

    // いいね機能レンダリング;
    // if (this.user !== 0) {
    //   console.log("this.user", this.user);
    //   let current_user_id = this.user.id;
    //   console.log("this.post_image", this.post_image);
    //   this.post_image.favorites.map(fav => {
    //     console.log("fav", fav);
    //     console.log(
    //       "fav.end_user_id === current_user_id",
    //       fav.end_user_id === current_user_id
    //     );
    //     console.log("typeOf fav.end_user_id", typeof fav.end_user_id);
    //     console.log("fav.end_user_id", fav.end_user_id);
    //     console.log("typeof current_user_id", typeof current_user_id);
    //     console.log("current_user_id", current_user.id);
    //     console.log("this.user_id", this.user_id);
    //     if (fav.end_user_id === current_user_id) {
    //       this.post_image.isFav = true;
    //       console.log("this.post_image.isFav", this.post_image.isFav);
    //       return true;
    //     } else {
    //       this.post_image.isFav = false;
    //       return false;
    //     }
    //   });
    //   console.log("this.post_image", this.post_image);
    //   console.log(
    //     "this.post_image.isFav !== true || undefined",
    //     this.post_image.isFav === true
    //   );
    // }

    // caption内のハッシュタグを削除する処理
    this.post_image.caption = this.post_image.caption.replace(
      /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
      ""
    );

    console.log("this.post_image.caption", this.post_image.caption);

    this.post_image.hashtags.map(hashtag => {
      hashtag.hashname.replace(/[#＃]/gm, "");
    });
    this.post_image.isActive = true;
    this.post_image.showBtn = false;

    const unwatch = this.$store.watch(
      state => state.user,
      async (newUser, oldUser) => {
        if (newUser.id) {
          try {
            const res = await axios.get(
              `${this.baseUrl}/post_images/${this.$route.params.id}`
            );
            let current_user_id = this.user.id;
            // console.log("current_user_id", current_user_id);
            this.post_image = res.data;

            // this.post_image.favorites.each(fav => {
            //   if (fav.end_user_id === current_user_id) {
            //     res.data.isFav = true;
            //     // return true;
            //   } else {
            //     // return
            //     res.data.isFav = false;
            //   }
            // });

            this.post_image.favorites.map(fav => {
              // console.log("fav", fav);
              // console.log(
              //   "fav.end_user_id === current_user_id",
              //   fav.end_user_id === current_user_id
              // );
              // console.log("typeOf fav.end_user_id", typeof fav.end_user_id);
              // console.log("fav.end_user_id", fav.end_user_id);
              // console.log("typeof current_user_id", typeof current_user_id);
              // console.log("current_user_id", current_user_id);
              // console.log("this.user_id", this.user.id);
              if (fav.end_user_id === current_user_id) {
                this.post_image.isFav = true;
                // console.log("this.post_image.isFav", this.post_image.isFav);
                return true;
              } else {
                this.post_image.isFav = false;
                return false;
              }
            });

            this.post_image.caption = this.post_image.caption.replace(
              /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
              ""
            );
            console.log("this.post_image.caption", this.post_image.caption);

            this.post_image.hashtags.map(hashtag => {
              hashtag.hashname.replace(/[#＃]/gm, "");
            });
            this.post_image.isActive = true;
            this.post_image.showBtn = false;
          } catch (err) {
            console.log("err", err);
          }
        }
      }
    );
  },
  async asyncData({ params }) {
    try {
      const res = await axios.get(
        `${process.env.BASE_URL}/post_images/${params.id}`
      );
      return {
        raw_post_image: res.data
      };
    } catch (err) {
      console.log("err", err);
    }
  },
  async mounted() {
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
      const res = await axios.get(
        `${this.baseUrl}/post_images/${this.$route.params.id}`
      );
      const favorite = {
        end_user_id: this.user.id
      };
      this.post_image = res.data;
      this.post_image.isFav = this.post_image.favorites.some(
        fav => fav.end_user_id === favorite.end_user_id
      );

      this.post_image.caption = this.post_image.caption.replace(
        /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
        ""
      );
      console.log("this.post_image.caption", this.post_image.caption);

      this.post_image.hashtags.map(hashtag => {
        hashtag.hashname.replace(/[#＃]/gm, "");
      });
    },
    async saveComment() {
      try {
        this.dialog = false;
        const comment = {
          comment: this.post_comment,
          end_user: this.user
        };

        const { data } = await axios.post(
          `/post_images/${this.post_image.id}/post_comments`,
          comment
        );
        // this.post_image.post_comments = data;
        await this.updatePostImages();
        this.post_comment = "";
      } catch (error) {
        alert(error);
      }
    },
    async createFavorite(post_image) {
      try {
        let vm = {
          post_image_id: post_image.id,
          end_user_id: this.user.id
        };
        await axios.post(`/post_images/${post_image.id}/favorites`, vm);
        await this.updatePostImages();
        post_image.isFav = true;
      } catch (error) {
        alert(error);
      }
    },
    async destroyFavorite(post_image) {
      let that = this;
      const ps = post_image.favorites.map(fav => {
        if (fav.end_user_id === that.user.id) {
          return fav;
        }
      });
      try {
        let byeFav = ps.filter(Boolean);
        await axios.delete(
          `/post_images/${post_image.id}/favorites/${byeFav[0].id}`
        );
        this.updatePostImages();
        post_image.isFav = false;
      } catch (error) {
        alert(error);
      }
    },
    async deletePostImage(post_image) {
      const res = await axios.delete(
        `/post_images/${post_image.id}`,
        post_image.id
      );
      this.post_image = res.data;
      this.$router.push("/post_Images");
    },
    showComments(post_image) {
      post_image.isActive = false;
      post_image.showBtn = true;
    },
    closeComments(post_image) {
      post_image.isActive = true;
      post_image.showBtn = false;
    }
  }
  // async fetch({ store }) {
  //   await store.dispatch("authCheck");
  // }
};
</script>

<style scoped>
a {
  text-decoration: none;
}
.maxHeight {
  max-height: 300px;
  overflow: hidden;
}
.showBtn {
  display: none;
}
</style>