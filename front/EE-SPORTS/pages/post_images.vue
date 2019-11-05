<template>
  <v-container>
    <div>
      <div v-for="(post_image, index) in post_images" :key="index">
        {{ post_image.id }}
        {{ post_image.post_image_id }}
        {{ post_image.current_user }}
        <img v-bind:src="'http://localhost:3001/' + post_image.image_name">
      </div>
    </div>
  </v-container>
</template>

<script>
// import axios from "~/plugins/axios";
import axios from 'axios'

const url = "http://localhost:3001//post_images.json"

export default {
  data() {
    return {
      post_images: [],
      post_image: "",
    };
  },
  mounted: async function() {
    const response = await axios.get(url)
    console.log(response)
    this.post_images = response.data.post_images;
  }
}

</script>


<style>

</style>
