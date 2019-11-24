<template>
  <v-container fluid>
    <v-row justify="center">
      <v-subheader>Today</v-subheader>

      <v-expansion-panels popout>
        <v-expansion-panel v-for="(message, i) in comments" :key="i" hide-actions>
          <v-expansion-panel-header>
            <v-row align="center" class="spacer" no-gutters>
              <v-col cols="4" sm="2" md="1">
                <v-avatar size="36px">
                  <img v-if="message.avatar" alt="Avatar" :src="message.avatar" />
                  <v-icon v-else :color="message.color" v-text="message.icon"></v-icon>
                </v-avatar>
              </v-col>

              <v-col class="hidden-xs-only" sm="5" md="3">
                <strong v-html="message.name"></strong>
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
                <strong v-html="message.title"></strong>
              </v-col>

              <v-col v-if="message.excerpt" class="grey--text text-truncate hidden-sm-and-down">
                &mdash;
                {{ message }}
              </v-col>
            </v-row>
          </v-expansion-panel-header>

          <v-expansion-panel-content>
            <v-divider></v-divider>
            <v-card-text v-text="message.lorem"></v-card-text>
          </v-expansion-panel-content>
        </v-expansion-panel>
      </v-expansion-panels>
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
  async created() {
    // if (this.$store.state.user.id === 0)
    // {
    console.log("created1");

    try {
      const res = await axios.get(url);
      console.log("res", res);
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
          // debugger;
        });
        post_image.isActive = true;
        post_image.showBtn = false;
        return post_image;
      });
      console.log("this.post_images", this.post_images);
    } catch (err) {
      console.log(err);
    }

    const unwatch = this.$store.watch(
      state => state.user,
      async (newUser, oldUser) => {
        console.log("あああああd1");

        if (newUser && newUser.id != 0) {
          try {
            const res = await axios.get(url);
            let current_user_id = this.user.id;
            console.log("current_user_id", current_user_id);
            this.post_images = res.data.map(post_image => {
              console.log("post_image.favorites", post_image.favorites);
              post_image.favorites.forEach(fav => {
                if (fav.end_user_id === current_user_id) {
                  return (post_image.isFav = true);
                } else {
                  return (post_image.isFav = false);
                }
              });
              // post_image.isFav = post_image.favorites.map(fav => {
              //   // if (fav.end_user_id) {
              //   fav.end_user_id === current_user_id;
              //   console.log("fav", fav);
              //   console.log("current_user", current_user_id);
              //   return fav;
              //   // }
              // });
              post_image.caption = post_image.caption.replace(
                /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
                ""
              );
              post_image.hashtags.map(hashtag => {
                hashtag.hashname.replace(/[#＃]/gm, "");
                // debugger;
              });
              post_image.isActive = true;
              post_image.showBtn = false;
              return post_image;
              console.log("fav_post_image", post_image);
            });
            console.log("this.post_images", this.post_images);
          } catch (err) {
            console.log("err", err);
          }
        } else {
          try {
            const res = await axios.get(url);
            console.log("res", res);
            this.post_images = res.data.map(post_image => {
              post_image.caption = post_image.caption.replace(
                /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
                ""
              );
              post_image.hashtags.map(hashtag => {
                hashtag.hashname.replace(/[#＃]/gm, "");
                // debugger;
              });
              return post_image;
            });
            console.log("this.post_images", this.post_images);
          } catch (err) {
            console.log(err);
          }
        }
        console.log("his.post_images", this.post_images);
      }
    );
  },
  async mounted() {
    if (this.$store.state.user.id !== 0) {
      console.log("notificationsCheck", this.$store.state.user);
      await this.$store.dispatch("notificationsCheck", this.$store.state.user);
    }
  },
  // ==============================ここ=============================
  computed: {
    user() {
      return this.$store.state.user;
    },
    filterdPostImages() {
      console.log("filtered");
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
      console.log("search_vm", vm);
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
    },
    comments() {
      {
        let commentsArray = [];
        this.post_images.forEach(post_image => {
          // let comments_list =
          post_image.post_comments.forEach(post_comment => {
            console.log("post_comment", post_comment);
            commentsArray.push({
              avatar:
                process.env.baseUrl +
                `/end_users/${post_comment.end_user.profile_image_name}`,
              name: post_comment.end_user.profile_name,
              title: post_comment.comment.slice(0, 10),
              lorem: post_comment.comment
            });
          });
        });

        console.log("commentsArray", commentsArray);
        return commentsArray;
      }
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
    },
    showComments(post_image) {
      post_image.isActive = false;
      post_image.showBtn = true;
    },
    closeComments(post_image) {
      post_image.isActive = true;
      post_image.showBtn = false;
    }
  },
  async fetch({ store }) {
    await store.dispatch("authCheck");
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