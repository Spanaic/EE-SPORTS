<template>
  <v-container>
    <v-row>
      <v-col cols="7">
        <!-- メインコンテンツのスクロール化 -->
        <!-- <v-responsive class="overflow-y-auto" max-height="600">
          <v-lazy
            v-model="isActive"
            :options="{
          threshold: .5
        }"
            min-height="200"
            transition="fade-transition"
        >-->
        <div>
          <!-- 今まで動いてたやつ -->
          <div
            v-for="(post_image, i) in $store.state.search.length ?  $store.state.search : filterdPostImages"
            :key="i"
          >
            <!-- 投稿一覧のカード表示とオーバーレイの組み込み -->

            <!-- hashtag付きで、これから試すv-for -->
            <!-- <div v-for="(post_image, i) in post_images" :key="i"> -->
            <!-- 投稿一覧のカード表示とオーバーレイの組み込み -->

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
                <v-card-title></v-card-title>
              </v-img>
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

              <v-card-subtitle class="pb-0"></v-card-subtitle>

              <v-card-text class="text--primary">
                <v-item-group multiple>
                  <!-- <nuxt-link :to="`/post_Images/hashtag/${hashtag.hashname}`"> -->
                  <!-- <div class="text-left">
                    <v-badge color="teal" left>
                      <template v-slot:badge>
                        <v-icon dark>mdi-pound</v-icon>
                      </template>
                      <span>{{ hashtag.hashname }}</span>
                    </v-badge>
                  </div>-->
                  <!-- <v-row> -->
                  <!-- <div class="d-flex"> -->
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

                  <v-divider class="my-4 info" style="opacity: 0.22"></v-divider>
                </v-item-group>
                <div>{{post_image.caption}}</div>
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

                <!-- お気に入り機能ボタンボタン（作りかけ） -->
                <template v-if="!post_image.isFav">
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

              <v-col cols="12" lg="12" sm="6" md="3">
                <!-- <v-text-field label="Outlined" outlined></v-text-field> -->
              </v-col>
            </v-card>
          </div>
        </div>
        <!-- </v-lazy>
        </v-responsive>-->
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
        >
          <!-- <input type="text" v-model="keyword" /> -->
        </v-text-field>

        <!-- <v-card class="mx-auto" max-width="434" tile>
          <v-img height="100%" src="https://cdn.vuetifyjs.com/images/cards/server-room.jpg">
            <v-row align="end" class="fill-height">
              <v-col align-self="start" class="pa-0" cols="12">
                <v-avatar class="profile" color="grey" size="164" tile>
                  <v-img src="https://cdn.vuetifyjs.com/images/profiles/marcus.jpg"></v-img>
                </v-avatar>
              </v-col>
              <v-col class="py-0">
                <v-list-item color="rgba(0, 0, 0, .4)" dark>
                  <v-list-item-content>
                    <v-list-item-title class="title">Marcus Obrien</v-list-item-title>
                    <v-list-item-subtitle>Network Engineer</v-list-item-subtitle>
                  </v-list-item-content>
                </v-list-item>
              </v-col>
            </v-row>
          </v-img>
        </v-card>-->

        <!-- <v-card class="mx-auto" max-width="300" tile>
          <v-list rounded>
            <v-subheader>REPORTS</v-subheader>
            <v-list-item-group v-model="item" color="primary">
              <v-list-item v-for="(item, i) in items" :key="i">
                <v-list-item-icon>
                  <v-icon v-text="item.icon"></v-icon>
                </v-list-item-icon>
                <v-list-item-content>
                  <v-list-item-title v-text="item.text"></v-list-item-title>
                </v-list-item-content>
              </v-list-item>
            </v-list-item-group>
          </v-list>
        </v-card>-->

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

                <!-- <v-card-title class="white--text pl-12 pt-12">
                <div class="display-1 pl-12 pt-12">Ali Conners</div>
                </v-card-title>-->
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
import firebase from "@/plugins/firebase";
// import Vuex from "vuex";
// import commentForm from "@/components/commentForm";

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
      isActive: false,
      // end_users_list
      current_user: []
    };
  },
  // components: {
  //   commentForm
  // },
  async mounted() {
    // await firebase.auth().onAuthStateChanged(async user => {
    //   console.log("firebase_user", user);
    //   if (user) {
    //     console.log("firebase", user);
    //     const { data } = await axios.get(`/end_users?email=${user.email}`);
    //     console.log("data", data[0]);
    //     store.commit("setUser", data[0]);
    //     this.current_user = data;
    //     console.log("current_user", this.current_user);
    //   }
    // });
    const res = await axios.get(url);
    // for (this.post_images in { modal: false }) {
    let current_user_id = this.user.id;
    // これは動くやーつ
    // this.post_images = res.data.map(post_image => {
    //   post_image.isFav = post_image.favorites.some(
    //     fav => fav.end_user_id === favorite.end_user_id
    //   );
    //   return post_image;
    //   debugger;
    // });
    // ここまで動くやーつ

    // ここからhashtagを処理して返すやーつ
    // res.dataにpost_imagesがはいっているので、mapでばらし、
    // isFavというぷろぱてぃを定義
    // そこにpolst_image一つ一つに対するfavoritesをみて、someメソッドを使い、
    // そのfavoriteの中に一つでも自分のfavがあればtrueをかえし、isFavに代入
    this.post_images = res.data.map(post_image => {
      post_image.isFav = post_image.favorites.some(fav =>
        console.log(
          "fav.end_user_id === current_user_id",
          fav.end_user_id === current_user_id,
          "fav",
          fav,
          "current_user_id",
          current_user_id
        )
      );
      console.log("post_image.isFavpost_image.isFav", post_image.isFav);

      // post_image.caption = post_image.caption.replace(
      //   /[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/,
      //   this.post_image.hashtag.hashname
      // );
      // console.log(post_image);

      // 受け取ったhashnameを<a>タグのリンクに変換完了
      // post_image.hashtag_list = post_image.hashtags.map(hashtag => {
      //   console.log("----------");
      //   console.log(post_image.hashtags);
      //   console.log("----------");
      //   hashtag.hashname = hashtag.hashname
      //     .split(["#", "＃"])
      //     // FIXME:rails側で修正するか、js側でsplit&joinする際に除外するか..(#記号の話)
      //     // 全角と半角をsplitする方法とは？
      //     .join("")
      //     .link(`/post/hashtag/${hashtag.hashname}`);
      //   return hashtag;
      //   console.log(hashtag);
      // });

      post_image.caption = post_image.caption.replace(
        /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
        ""
      );

      post_image.hashtags.map(hashtag => {
        hashtag.hashname.replace(/[#＃]/gm, "");
      });

      // // captionからhashtagを覗いた文字列を返すことに成功。
      // // これをcaptionに表示して、hashtagsをv-forで回して,aタグ付きのhashnameを表示すれば完成。
      // let only_caption = post_image.caption.replace(
      //   /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
      //   ""
      // );

      // console.log("yyyyyyyyyy");
      // console.log(only_caption);
      // console.log("yyyyyyyyyy");

      // // 変換したhashnameでcaptionに検索を掛けて、replaceする必要があり...
      // // リレーションで降りていくことはできるけど、リレーションを戻ることは出来ない？

      // let vms = post_image.caption.match(
      //   /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm
      // );
      // // captionからhashtagを一つずつ抜き出すことに成功

      // // let vm = post_image.caption.match(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/);
      // console.log("gggggggggg");
      // console.log(vms);
      // console.log("gggggggggg");

      // // post_image.hashtag = post_image.hashtags.map(hashtag => {
      // //   hashtag.post_image.caption.replace(
      // //     /[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/,
      // //     this.post_image.hashtag.hashname
      // //   );
      // //   return hashtag;
      // // });

      return post_image;
      // debugger;
    });
    // ここまで
    console.log(this.post_images);
    // this.favorite_list = res.data.favorites;
    console.log(this.$store.state.user.profile_image_name);
    // if this.post-images.end_user_id = this.$store.state.user.id;

    // hashtag機能ために追記した部分
    // const post_images_with_hashtags = this.post_images.map(
    //   post_image => {
    //     debugger;
    //     post_image.hashtag_list = post_image.hashtags.map(hashtag => {
    //       console.log("----------");
    //       console.log(post_image);
    //       console.log("----------");
    //       post_image_hashname = hashtag
    //         .replace("#", "")
    //         .link(`/post/hashtag/${hashtag.hashname}`);
    //       return hashtag;
    //     });
    //     return post_image;
    //     // post_image.link = this.post_image.caption.replace(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/).link(`/post/hashtag/${this.post_image.caption.delete("#")}`)
    //   }
    //   // this.post_images_with_links = this.post_images.map(post_image => {
    //   //   post_image.link = this.post_image.hashtags.map(hashtag => {
    //   //     hashtag.replace()
    //   // })
    //   // })
    // );
    // // return post_image;
    // const post_images_with_links = this.post_images_with_hashtags.map(
    //   post_image => {
    //     post_image.hashtag = post_image.hashtags.map(hashtag => {
    //       hashtag.post_image.caption.replace(
    //         /[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/,
    //         this.post_image.hashtag.hashname
    //       );
    //       return hashtag;
    //     });
    //     return post_image;
    //   }
    // );
    // hashtagここまで
  },
  // ==============================ここ=============================
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
      return vm.map(
        search_results => {
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
        }
        // filterdPostImages: function() {
        //   let results = this.post_images;
        //   for (let i in this.results) {
        //     let result = this.results[i];
        //     console.log(this.results);
        //     if (
        //       result.title.indexOf(this.keyword) !== -1 ||
        //       result.caption.indexOf(this.keyword) !== -1
        //     ) {
        //       results.push(result);
        //     }
        //   }
        //   return results;
        // }
      );
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

      // .then(res => {
      //   this.post_comment = res.data.post_comment;
      // });
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