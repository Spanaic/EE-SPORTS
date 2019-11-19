<template>
  <v-container>
    <v-row>
      <v-col cols="7">
        <div>
          <div v-for="(post_image, i) in filterdPostImages" :key="i">
            <v-toolbar color="indigo" dark>
              <v-list-item>
                <v-list-item-avatar>
                  <v-img
                    :src="'http://localhost:3001/end_users/' + `${post_image.end_user.profile_image_name}`"
                  ></v-img>
                </v-list-item-avatar>
                <v-list-item-content>
                  <v-list-item-title class="headline">{{ post_image.title }}</v-list-item-title>
                  <v-list-item-subtitle>by {{ post_image.end_user.profile_name }}</v-list-item-subtitle>
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
              <v-overlay :absolute="absolute" :opacity="opacity" :value="overlay" :z-index="zIndex">
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
                <v-item-group multiple>
                  <v-subheader>ハッシュタグ</v-subheader>
                  <v-item
                    v-for="(hashtag, i) in post_image.hashtags"
                    :key="i"
                    v-slot:default="{ active, toggle }"
                  >
                    <nuxt-link :to="`/post_Images/hashtag/${hashtag.hashname}`">
                      <v-chip
                        active-class="purple--text"
                        :input-value="active"
                        @click="toggle"
                      >{{ hashtag.hashname }}</v-chip>
                    </nuxt-link>
                  </v-item>
                </v-item-group>
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

                <!-- お気に入り機能ボタン -->
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

                <!-- <comment-form></comment-form> -->
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
        <!-- {{ this.user }} -->
        <div v-if="this.$store.state.user">
          <v-card max-width="375" class="mx-auto">
            <v-img
              :src="'http://localhost:3001/end_users/' + `${this.$store.state.user.profile_image_name}`"
              height="auto"
              dark
            >
              <v-row class>
                <v-card-title>
                  <v-btn dark icon>
                    <v-icon>mdi-chevron-left</v-icon>
                  </v-btn>

                  <v-spacer></v-spacer>

                  <v-btn dark icon class="mr-4">
                    <v-icon>mdi-pencil</v-icon>
                  </v-btn>

                  <v-btn dark icon>
                    <v-icon>mdi-dots-vertical</v-icon>
                  </v-btn>
                </v-card-title>

                <v-spacer></v-spacer>
              </v-row>
            </v-img>

            <v-list two-line>
              <v-list-item @click>
                <v-list-item-icon>
                  <v-icon color="indigo">mdi-phone</v-icon>
                </v-list-item-icon>

                <v-list-item-content>
                  <v-list-item-title>{{ this.$store.state.user.name }}</v-list-item-title>
                  <v-list-item-subtitle>お名前</v-list-item-subtitle>
                </v-list-item-content>

                <v-list-item-icon>
                  <v-icon>mdi-message-text</v-icon>
                </v-list-item-icon>
              </v-list-item>

              <v-list-item @click>
                <v-list-item-action></v-list-item-action>

                <v-list-item-content>
                  <v-list-item-title>{{ this.$store.state.user.profile_name }}</v-list-item-title>
                  <v-list-item-subtitle>ニックネーム</v-list-item-subtitle>
                </v-list-item-content>

                <v-list-item-icon>
                  <v-icon>mdi-message-text</v-icon>
                </v-list-item-icon>
              </v-list-item>

              <v-divider inset></v-divider>

              <v-list-item @click>
                <v-list-item-icon>
                  <v-icon color="indigo">mdi-email</v-icon>
                </v-list-item-icon>

                <v-list-item-content>
                  <v-list-item-title>{{ this.$store.state.user.email }}</v-list-item-title>
                  <v-list-item-subtitle>Personal</v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>

              <v-list-item @click>
                <v-list-item-action></v-list-item-action>

                <v-list-item-content>
                  <v-list-item-title>ali_connors@example.com</v-list-item-title>
                  <v-list-item-subtitle>Work</v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>

              <v-divider inset></v-divider>

              <v-list-item @click>
                <v-list-item-icon>
                  <v-icon color="indigo">mdi-map-marker</v-icon>
                </v-list-item-icon>

                <v-list-item-content>
                  <v-list-item-title>1400 Main Street</v-list-item-title>
                  <v-list-item-subtitle>Orlando, FL 79938</v-list-item-subtitle>
                </v-list-item-content>
              </v-list-item>
            </v-list>
          </v-card>
        </div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from "@/plugins/axios";
import { mdiPound } from "@mdi/js";
import { mdiPoundBoxOutline } from "@mdi/js";
import { mdiThumbUp } from "@mdi/js";
import { mdiThumbUpOutline } from "@mdi/js";

const url = "http://localhost:3001/post_images";

export default {
  data() {
    return {
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
      // v-lazy
      isActive: false
    };
  },
  async created() {
    const res = await axios.get(url);
    // for (this.post_images in { modal: false }) {
    console.log(res.data);
    // }
    const favorite = {
      end_user_id: this.user.id
    };

    // ここからhashtagを処理して返すやーつ
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

      return post_image;
      debugger;
    });
    // ここまで
    console.log(this.post_images);
    console.log(this.$store.state.user.profile_image_name);
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
    },
    // search結果をstoreから受け取って表示するための値
    searchResults() {
      let vm = this.$store.state.search;
      console.log("-------------");
      console.log(vm);
      console.log("-------------");
      return vm.map(search_results => {
        console.log("-------------");
        console.log(search_results);
        console.log("-------------");
        search_results.filter(search_result => {
          console.log("-------------");
          console.log(search_result);
          console.log("-------------");
          console.log("-------------");
          console.log(vm.keyword == search_result.title);
          console.log(vm.keyword == search_result.caption);
          console.log("-------------");
          return (
            vm.keyword == search_result.title ||
            vm.keyword == search_result.caption
          );
        });
      });
    }
  },
  methods: {
    setPostImage(postImage) {
      this.post_image = postImage;
    },

    async updatePostImages() {
      const res = await axios.get(url);
      console.log(res.data);
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
        return post_image;
      });
    },
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
      } catch (error) {
        alert(error);
      }
    },
    async createFavorite(post_image) {
      try {
        await axios.post(`/post_images/${post_image.id}/favorites`, post_image);
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
      // debugger;
      console.log({ ps });
      try {
        await axios.delete(
          `/post_images/${post_image.id}/favorites/${ps[0].id}`
        );
        this.updatePostImages();
        post_image.isFav = false;
      } catch (error) {
        alert(error);
      }
    }
  }
};
</script>