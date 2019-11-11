<template>
  <div>
    <div v-for="(post_image, i) in post_images" :key="i">
      <v-card class="mx-auto" max-width="400">
        <nuxt-link :to="`/post_images/${ post_image.id }`">
          <v-img
            class="white--text align-end"
            height="200px"
            :src="'http://localhost:3001/post_images/' + post_image.image_name"
          >
            <v-card-title>Top 10 Australian beaches</v-card-title>
          </v-img>
        </nuxt-link>

        <v-card-subtitle class="pb-0">Number 10</v-card-subtitle>

        <v-card-text class="text--primary">
          <div>{{post_image.caption}}</div>

          <div>Whitsunday Island, Whitsunday Islands</div>
        </v-card-text>

        <v-card-actions>
          <v-btn color="orange" text>Share</v-btn>

          <v-btn color="orange" text>Explore</v-btn>

          <v-btn icon>
            <v-icon>mdi-heart</v-icon>
          </v-btn>
          <commentForm></commentForm>
        </v-card-actions>

        <v-col cols="12" lg="12" sm="6" md="3">
          <!-- <v-text-field label="Outlined" outlined></v-text-field> -->
        </v-col>
      </v-card>
    </div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import Vuex from "vuex";
import commentForm from "@/components/commentForm";

const url = "http://localhost:3001/post_images.json";

export default {
  data() {
    return {
      post_images: [],
      post_image: ""
    };
  },
  components: {
    commentForm
  },
  mounted: async function() {
    const res = await axios.get(url);
    this.post_images = res.data.post_images;
  }
};
</script>