<template>
  <v-container>
    <div>
      <div v-for="(post_image, index) in post_images" :key="index">
        <img v-bind:src="'http://localhost:3001/post_images/' + post_image.image_name" />
        {{ post_image.caption }}
      </div>
    </div>
  </v-container>
</template>

<script>
import axios from "@/plugins/axios";

const url = "http://localhost:3001/post_images.json";

export default {
  data() {
    return {
      post_images: [],
      post_image: ""
    };
  },
  //   created: async function() {
  //     const user = this.$store.state.user;
  //     await axios.post("/post_images", { user });
  //   },
  mounted: async function() {
    const response = await axios.get(url);
    console.log(response);
    this.post_images = response.data.post_images;
  }
};
</script>


<style>
</style>

  // create_table "post_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
  //   t.integer "user_id"
  //   t.text "caption"
  //   t.string "image_name"
  // end