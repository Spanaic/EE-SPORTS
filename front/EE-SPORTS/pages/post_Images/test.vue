<template>
  <v-container>
    <v-row>
      <v-col cols="7">
        <div>
          <!-- 今まで動いてたやつ -->
          <div v-for="(post_image, i) in filterdPostImages" :key="i">
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
                  <nuxt-link :to="`/post_Images/hashtag/${hashtag.hashname}`">
                    <!-- <v-flex> -->
                    <!-- <div> -->
                    <v-chip class="ma-2" color="secondary">{{ hashtag.hashname }}</v-chip>
                    <!-- </div> -->
                    <!-- </v-flex> -->
                  </nuxt-link>
                  <!-- </div> -->

                  <!-- </v-row> -->
                  <!-- </nuxt-link> -->
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

                <!-- お気に入り機能ボタンボタン（作りかけ） -->
                <template v-if="!post_image.isFav">
                  <v-btn icon @click="createFavorite(post_image)">
                    <v-icon>mdi-heart-outline</v-icon>
                  </v-btn>
                </template>
                <template v-else>
                  <v-btn icon @click="destroyFavorite(post_image)">
                    <v-icon>mdi-heart</v-icon>
                  </v-btn>
                </template>

                <!-- <comment-form></comment-form> -->
                <!-- コメント入力のダイアログ -->
                <v-row justify="center">
                  <v-dialog v-model="dialog" persistent max-width="600px">
                    <template v-slot:activator="{ on }">
                      <v-btn color="primary" dark v-on="on">コメントする</v-btn>
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
                        {{post_image}}
                        <v-btn color="blue darken-1" text @click="saveComment(post_image)">Save</v-btn>
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
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from "@/plugins/axios";
import { mdiPound } from "@mdi/js";
import { mdiPoundBoxOutline } from "@mdi/js";
// import Vuex from "vuex";
// import commentForm from "@/components/commentForm";

const url = "http://localhost:3001/post_images";

export default {
  data() {
    return {
      keyword: "",
      post_images: [],
      post_image: "",
      dialog: false,
      post_comments: [],
      post_comment: "",
      favoriteCheck: false,
      favorite_list: [],
      absolute: true,
      overlay: false
    };
  },
  // components: {
  //   commentForm
  // },
  async created() {
    const res = await axios.get(url);
    // for (this.post_images in { modal: false }) {
    console.log(res.data);
    // }
    const favorite = {
      end_user_id: this.user.id
    };
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
    this.post_images = res.data.map(post_image => {
      post_image.isFav = post_image.favorites.some(
        fav => fav.end_user_id === favorite.end_user_id
      );

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
      debugger;
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
  },
  methods: {
    async saveComment(post_image) {
      console.log(post_image.id);
      try {
        this.dialog = false;
        console.log(this);
        const comment = {
          comment: this.post_comment
        };
        const { data } = await axios.post(
          `/post_images/${post_image.id}/post_comments`,
          comment
        );
        console.log({ data });
        post_image.post_comments = data;
      } catch (error) {
        alert("");
      }

      // .then(res => {
      //   this.post_comment = res.data.post_comment;
      // });
    },
    async createFavorite(post_image) {
      try {
        await axios.post(`/post_images/${post_image.id}/favorites`, post_image);
        post_image.isFav = true;
      } catch (error) {
        alert("");
      }
    },
    destroyFavorite(post_image) {
      let vm = this;
      const ps = post_image.favorites.map(fav => {
        if (fav.end_user_id === vm.user.id) {
          return fav;
        }
      });

      console.log({ ps });
      try {
        axios.delete(
          `/post_images/${post_image.id}/favorites/${post_image.favorites}/${ps[0].id}`
        );
        post_image.isFav = false;
      } catch (error) {
        alert("");
      }
    }
  }
};
</script>