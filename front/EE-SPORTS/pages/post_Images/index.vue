<template>
  <div>
    <div v-for="(post_image, index) in post_images" :key="index">
      <!-- <nuxt-link :to="{name: 'post_Images-id', params: { postImageId: post_image.id }}"> -->
      <nuxt-link :to="`/post_images/${ post_image.id }`">
        <!-- <button @click="showPostImage"> -->
        <img v-bind:src="'http://localhost:3001/post_images/' + post_image.image_name" />
        <!-- </button> -->
      </nuxt-link>
      {{ post_image.caption }}
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
  //   created: async function() {
  //     const user = this.$store.state.user;
  //     await axios.post("/post_images", { user });
  //   },
  //   created: () => {
  //       store.commit('setUser', user)
  //   },
  mounted: async function() {
    const response = await axios.get(url);
    console.log(response);
    this.post_images = response.data.post_images;
  }
  //   methods: {
  //     showPostImage() {
  //       this.$router.push(`post_images/${post_image.id}`, post_image.id);
  //     }
  //   }
};
</script>


<style>
</style>

  // create_table "post_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  //   t.integer "user_id"
  //   t.text "caption"
  //   t.string "image_name"
  // end