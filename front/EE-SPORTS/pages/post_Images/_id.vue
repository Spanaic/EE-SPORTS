<template>
  <div>
    <img v-bind:src="'http://localhost:3001/post_images/' + post_image.image_name" />
  </div>
  <!-- {{ post_image.caption }} -->
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      post_image: {}
    };
  },
  mounted() {
    axios
      .get(`/post_images/${this.$route.params.id}`)
      .then(res => {
        console.log(res);
        this.post_image = res.data;
      })
      .catch(function(error) {
        console.log("ERROR!! occurred in Backend.", error);
      });
  }
};

// import axios from "@/plugins/axios";

// export default {
//   data() {
//     return {
//       post_image: {}
//     };
//   },
//   mounted: async () => {
//     await axios
//       .get(`/post_images?post_image=${this.$route.params}`)
//       .then(res => {
//         console.log(res);
//         this.post_image = res.data.post_image;
//       })
//       .catch(function(error) {
//         console.log("ERROR!! occurred in Backend.", error);
//       });
//   }
// };
</script>

<style>
</style>