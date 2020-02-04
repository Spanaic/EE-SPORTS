<template>
  <div>
    <div>
      <v-card class="mx-auto mb-5" height="100%" max-width="800">
        <!--NOTE: カードのheader部分 -->
        <v-toolbar color="indigo" dark>
          <nuxt-link :to="`/end_users/${post_image.end_user.id}`">
            <v-list-item>
              <v-list-item-avatar>
                <!--NOTE: プロフィール画像の表示 -->
                <v-img
                  v-if="post_image.end_user.profile_image_name"
                  :src="`${baseUrl}/end_users/${post_image.end_user.profile_image_name}`"
                ></v-img>
                <!--NOTE: プロフィール画像未設定のno_imageの条件分岐 -->
                <v-img v-else :src="`${baseUrl}/no_image.jpg`"></v-img>
              </v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title class="headline">{{ post_image.title }}</v-list-item-title>
                <v-list-item-subtitle>by {{ post_image.end_user.profile_name }}</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </nuxt-link>

          <!--NOTE: メニュー用の空間を作ってる -->
          <v-row>
            <v-col cols="12" sm="6" offset-sm="3">
              <v-spacer></v-spacer>
            </v-col>
          </v-row>

          <!--NOTE: 編集&削除用アイコンメニュー -->
          <!-- currentUserが投稿者でなければメニューは表示されない -->
          <v-menu v-if="post_image.end_user_id === this.$store.state.user.id" bottom left>
            <template v-slot:activator="{ on }">
              <v-btn dark icon v-on="on">
                <v-icon>mdi-dots-vertical</v-icon>
              </v-btn>
            </template>

            <v-list>
              <v-list-item v-for="(item, i) in items" :key="i">
                <!--NOTE: 編集モーダル -->
                <v-list-item-title
                  v-if="item.title === '編集'"
                  @click.stop="openEditPage"
                >{{ item.title }}</v-list-item-title>
                <v-list-item-title v-if="item.title === '削除'" @click="deleteImage">{{ item.title }}</v-list-item-title>
              </v-list-item>
              <!--NOTE: モーダルの中身 -->
              <v-dialog v-model="edit_dialog" persistent max-width="600px">
                <v-card>
                  <v-card-title>
                    <span class="headline">画像編集ページ</span>
                  </v-card-title>
                  <v-card-text>
                    <v-container>
                      <v-row>
                        <v-col cols="12">
                          <v-text-field auto-grow label="title" v-model="post_image.title" required></v-text-field>
                        </v-col>

                        <v-col cols="12">
                          <v-textarea
                            auto-grow
                            label="caption"
                            v-model="post_image.caption"
                            required
                          ></v-textarea>
                        </v-col>
                      </v-row>
                    </v-container>
                    <small>※最低でも1文字は入力してね！</small>
                  </v-card-text>
                  <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue darken-1" text @click="edit_dialog = false">Close</v-btn>
                    <v-btn color="blue darken-1" text @click="editPostImage">Save</v-btn>
                  </v-card-actions>
                </v-card>
              </v-dialog>
            </v-list>
          </v-menu>
        </v-toolbar>

        <v-img
          class="white--text align-end"
          height="400px"
          :src="`${baseUrl}/post_images/${post_image.image_name}`"
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
          <div>{{caption_nohashtags}}</div>
          <v-divider class="my-4 info" style="opacity: 0.22"></v-divider>
        </v-card-text>

        <v-card-actions>
          <v-btn color="orange" text></v-btn>

          <v-btn color="orange" text></v-btn>

          <!--NOTE: お気に入り機能ボタン -->
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

            <!--NOTE: コメント入力のダイアログ -->
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
      // NOTE: hashtagを含んだcaption
      caption_nohashtags: "",
      raw_post_image: {},
      current_user: [],
      dialog: false,
      post_comments: [],
      post_comment: "",
      favoriteCheck: false,
      favorite_list: [],
      absolute: true,
      overlay: false,
      isActive: false,
      // NOTE:編集&削除メニュー
      items: [{ title: "編集" }, { title: "削除" }],
      // NOTE:編集用dialog
      edit_dialog: false
    };
  },
  filters: {
    commentsLength(comment) {
      return comment.length >= 10 ? comment.slice(0, 10) + "....." : comment;
    }
  },
  async created() {
    this.post_image = this.raw_post_image;
    // NOTE:いいね機能レンダリング
    if (this.$store.state.user !== 0) {
      let current_user_id = this.$store.state.user.id;
      this.post_image.favorites.map(fav => {
        if (fav.end_user_id === current_user_id) {
          this.post_image.isFav = true;
          return true;
        } else {
          this.post_image.isFav = false;
          return false;
        }
      });
    }

    // NOTE:caption内のハッシュタグを削除する処理
    this.replaceHashtags();
    this.post_image.hashtags.map(hashtag => {
      hashtag.hashname.replace(/[#＃]/gm, "");
    });
    this.post_image.isActive = true;
    this.post_image.showBtn = false;
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
      this.replaceHashtags();

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
    //TODO:続きを読むを実装するなら使用する、しないなら削除
    // showComments(post_image) {
    //   post_image.isActive = false;
    //   post_image.showBtn = true;
    // },
    // closeComments(post_image) {
    //   post_image.isActive = true;
    //   post_image.showBtn = false;
    // },

    // NOTE:画像削除
    async deleteImage() {
      try {
        if (confirm("本当に削除してよろしいですか")) {
          await axios.delete(`/post_images/${this.$route.params.id}`);
          this.$router.push("/post_Images");
        }
      } catch (err) {
        console.log("delete err", err);
      }
    },
    // NOTE:編集ページ用のdialogを開く
    openEditPage() {
      this.edit_dialog = true;
    },

    // NOTE:editモーダルで編集した内容を保存する
    async editPostImage() {
      console.log("this.$route.params.id", this.$route.params.id);
      try {
        const res = await axios.patch(
          `/post_images/${this.$route.params.id}`,
          this.post_image
        );
        this.updatePostImages();
        this.edit_dialog = false;
      } catch (err) {
        console.log("post_err", err);
        this.edit_dialog = false;
      }
    },

    // NOTE:説明文表示用にhashtagsを抜いた説明文
    replaceHashtags() {
      this.caption_nohashtags = this.post_image.caption.replace(
        /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
        ""
      );
      return this.caption_nohashtags;
    }
  }
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