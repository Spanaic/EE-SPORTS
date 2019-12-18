<template>
  <v-container>
    <v-row>
      <v-col cols="7">
        <div>
          <v-btn
            class="ma-2"
            outlined
            large
            fab
            color="indigo"
            v-if="$store.state.search.length !== 0 "
            @click="cancelSearch"
          >
            <v-icon>mdi-water-off</v-icon>
          </v-btn>
          <div
            v-for="(post_image, i) in $store.state.search.length ?  $store.state.search : filterdPostImages"
            :key="i"
          >
            <v-toolbar color="indigo" dark>
              <nuxt-link :to="`/end_users/${post_image.end_user.id}`">
                <v-list-item>
                  <v-list-item-avatar>
                    <!-- プロフィール画像の表示 -->
                    <v-img
                      v-if="post_image.end_user.profile_image_name"
                      :src="`${baseUrl}/end_users/${post_image.end_user.profile_image_name}`"
                    ></v-img>
                    <!-- プロフィール画像未設定のno_imageの条件分岐 -->
                    <v-img v-else :src="`${baseUrl}/no_image.jpg`"></v-img>
                  </v-list-item-avatar>
                  <v-list-item-content>
                    <v-list-item-title class="headline">{{ post_image.title }}</v-list-item-title>
                    <v-list-item-subtitle>by {{ post_image.end_user.profile_name }}</v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </nuxt-link>
            </v-toolbar>

            <v-card class="mx-auto mb-5" height="100%" max-width="800">
              <nuxt-link :to="`/post_Images/${ post_image.id }`">
                <v-img
                  class="white--text"
                  height="400px"
                  :src="`${baseUrl}/post_images/${post_image.image_name}`"
                >
                  <v-card-title></v-card-title>
                </v-img>
              </nuxt-link>

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

              <v-card-actions v-if="$store.state.user.id !== 0 ">
                <v-btn class="btnNone" color="orange" text></v-btn>

                <v-btn class="btnNone" color="orange" text></v-btn>

                <!-- お気に入り機能ボタン -->
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
                      <v-btn
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
                        <v-btn color="blue darken-1" text @click="saveCommentAtIndex()">Save</v-btn>
                      </v-card-actions>
                    </v-card>
                  </v-dialog>
                </v-row>
              </v-card-actions>

              <div :class="{ maxHeight: post_image.isActive}">
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
                              <nuxt-link :to="`/end_users/${message.end_user.id}`">
                                <v-avatar size="36px">
                                  <img
                                    v-if="message.end_user.profile_image_name"
                                    alt="Avatar"
                                    :src="`${baseUrl}/end_users/${message.end_user.profile_image_name}`"
                                  />
                                  <img v-else alt="Avatar" :src="`${baseUrl}/no_image.jpg`" />
                                </v-avatar>
                              </nuxt-link>
                            </v-col>

                            <v-col class="hidden-xs-only" sm="5" md="3">
                              <nuxt-link :to="`/end_users/${message.end_user.id}`">
                                <strong v-html="message.end_user.profile_name"></strong>
                              </nuxt-link>
                              <span
                                v-if="message.total"
                                class="grey--text"
                              >&nbsp;({{ message.total }})</span>
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
              </div>

              <v-btn
                block
                v-if="post_image.isActive === true"
                @click="showComments(post_image)"
                :class="{ showBtn: post_image.showBtn }"
              >続きを読む</v-btn>

              <v-btn
                block
                v-if="post_image.showBtn === true"
                @click="closeComments(post_image)"
              >コメントを閉じる</v-btn>

              <v-col cols="12" lg="12" sm="6" md="3"></v-col>
            </v-card>
          </div>
        </div>
      </v-col>

      <v-col cols="1"></v-col>
      <v-col cols="4">
        <v-text-field
          v-model="keyword"
          label="Filled"
          placeholder="Search"
          filled
          rounded
          dense
          outlined
        ></v-text-field>

        <!-- サイドバーのプロフィール画面 -->
        <div v-if="$store.state.user.id">
          <v-card max-width="375" class="mx-auto">
            <nuxt-link :to="`/end_users/${user.id}`">
              <v-img
                v-if="$store.state.user.profile_image_name"
                :src="`${baseUrl}/end_users/${$store.state.user.profile_image_name}`"
                height="auto"
                dark
              >
                <v-row class>
                  <v-spacer></v-spacer>
                </v-row>
              </v-img>
              <v-img v-else :src="`${baseUrl}/no_image.jpg`" height="auto" dark>
                <v-row class>
                  <v-spacer></v-spacer>
                </v-row>
              </v-img>

              <v-list two-line>
                <v-list-item @click>
                  <v-list-item-icon>
                    <v-icon color="white">mdi-account-circle</v-icon>
                  </v-list-item-icon>

                  <v-list-item-content>
                    <v-list-item-title>{{ this.$store.state.user.name }}</v-list-item-title>
                    <v-list-item-subtitle>お名前</v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>

                <v-list-item @click>
                  <v-list-item-icon>
                    <v-icon color="white">mdi-rename-box</v-icon>
                  </v-list-item-icon>

                  <v-list-item-content>
                    <v-list-item-title>{{ this.$store.state.user.profile_name }}</v-list-item-title>
                    <v-list-item-subtitle>ユーザー名</v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>

                <v-divider inset></v-divider>

                <v-list-item @click>
                  <v-list-item-icon>
                    <v-icon color="white">mdi-email</v-icon>
                  </v-list-item-icon>

                  <v-list-item-content>
                    <v-list-item-title>{{ this.$store.state.user.email }}</v-list-item-title>
                    <v-list-item-subtitle>Personal</v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </v-list>
            </nuxt-link>
          </v-card>
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from "@/plugins/axios";
import { mdiPound } from "@mdi/js";
import { mdiAccountCircle } from "@mdi/js";
import { mdiRenameBox } from "@mdi/js";
import { mdiPoundBoxOutline } from "@mdi/js";
import { mdiThumbUp } from "@mdi/js";
import { mdiThumbUpOutline } from "@mdi/js";
import { mdiWaterOff } from "@mdi/js";
import firebase from "@/plugins/firebase";

export default {
  data() {
    return {
      baseUrl: process.env.BASE_URL,
      keyword: "",
      post_images: [],
      post_image: {},
      dialog: false,
      post_comments: [],
      post_comment: "",
      favoriteCheck: false,
      favorite_list: [],
      absolute: true,
      overlay: false,
      isActive: false,
      current_user: []
    };
  },
  filters: {
    commentsLength(message) {
      return message.length >= 10 ? message.slice(0, 10) + "....." : message;
    }
  },
  async created() {
    try {
      const res = await axios.get(`${this.baseUrl}/post_images`);
      this.post_images = res.data.map(post_image => {
        post_image.favorites.forEach(fav => {
          if (fav.end_user_id === this.user.id) {
            return (post_image.isFav = true);
          } else {
            return (post_image.isFav = false);
          }
        });
        post_image.caption = post_image.caption.replace(
          /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
          ""
        );
        post_image.hashtags.map(hashtag => {
          hashtag.hashname.replace(/[#＃]/gm, "");
        });
        post_image.isActive = true;
        post_image.showBtn = false;
        return post_image;
      });
    } catch (err) {
      console.log(err);
    }

    const unwatch = this.$store.watch(
      state => state.user,
      async (newUser, oldUser) => {
        if (newUser && newUser.id != 0) {
          try {
            const res = await axios.get(`${this.baseUrl}/post_images`);
            let current_user_id = this.user.id;
            this.post_images = res.data.map(post_image => {
              post_image.favorites.forEach(fav => {
                if (fav.end_user_id === current_user_id) {
                  return (post_image.isFav = true);
                } else {
                  return (post_image.isFav = false);
                }
              });
              post_image.caption = post_image.caption.replace(
                /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
                ""
              );
              post_image.hashtags.map(hashtag => {
                hashtag.hashname.replace(/[#＃]/gm, "");
              });
              post_image.isActive = true;
              post_image.showBtn = false;
              return post_image;
            });
          } catch (err) {
            console.log("err", err);
          }
        }
      }
    );
  },
  async mounted() {
    if (this.$store.state.user.id !== 0) {
      await this.$store.dispatch("notificationsCheck", this.$store.state.user);
    }
  },
  computed: {
    user() {
      return this.$store.state.user;
    },
    filterdPostImages() {
      return this.post_images.filter(post_image => {
        return (
          post_image.title.includes(this.keyword) ||
          post_image.caption.includes(this.keyword) ||
          post_image.end_user.profile_name.includes(this.keyword)
        );
      });
    }
  },
  methods: {
    setPostImage(postImage) {
      this.post_image = postImage;
    },

    async updatePostImages() {
      const res = await axios.get(`${this.baseUrl}/post_images`);
      const favorite = {
        end_user_id: this.user.id
      };
      this.post_images = res.data.map(post_image => {
        post_image.isFav = post_image.favorites.some(
          fav => fav.end_user_id === favorite.end_user_id
        );
        post_image.caption = post_image.caption.replace(
          /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
          ""
        );
        post_image.hashtags.map(hashtag => {
          hashtag.hashname.replace(/[#＃]/gm, "");
        });
        post_image.isActive = true;
        post_image.showBtn = false;
        return post_image;
      });
    },
    async saveCommentAtIndex() {
      try {
        this.dialog = false;
        const comment = {
          comment: this.post_comment,
          end_user: this.user
        };

        const res = await axios.post(
          `/post_images/${this.post_image.id}/post_comments`,
          comment
        );
        this.post_image.post_comments = res.data.post_comments;
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
    showComments(post_image) {
      post_image.isActive = false;
      post_image.showBtn = true;
    },
    closeComments(post_image) {
      post_image.isActive = true;
      post_image.showBtn = false;
    },
    cancelSearch() {
      this.$store.dispatch("cancelSearch");
      this.$router.push("/post_Images");
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
  color: #fff;
}
.maxHeight {
  max-height: 330px;
  overflow: hidden;
}
.showBtn {
  display: none;
}
.btnNone {
  visibility: hidden;
}
</style>