<template>
  <div>
    <v-row>
      <v-col cols="12" sm="6" offset-sm="3">
        <div class="text-center">
          <v-chip class="ma-2" color="teal" text-color="white" large>
            <v-text class="display-1">{{ decodeHashtag($route.hash) }}</v-text>
          </v-chip>

          <v-card>
            <v-container fluid>
              <v-row>
                <v-col
                  v-for="(post_image, i) in hashtag_post_images"
                  :key="i"
                  class="d-flex child-flex"
                  cols="4"
                >
                  <nuxt-link :to="`/post_Images/${post_image.id}`">
                    <v-card flat tile class="d-flex">
                      <v-img
                        :src="'http://localhost:3001/post_images/' + `${post_image.image_name}`"
                        :lazy-src="'http://localhost:3001/post_images/' + `${post_image.image_name}`"
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
        </div>
      </v-col>
    </v-row>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      hashtag_post_images: []
    };
  },
  async mounted() {
    await this.$store.dispatch("notificationsCheck", this.$store.state.user);
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    }
  },
  methods: {
    decodeHashtag(hashtag) {
      let japaneseTag = decodeURIComponent(hashtag);
      return japaneseTag;
    }
  },
  async created() {
    const url = this.$route.hash.replace(/[#＃]/gm, "");
    const res = await axios.get("/post/hashtag/" + url);
    this.hashtag_post_images = res.data;
  }
};
</script>

<style>
</style>