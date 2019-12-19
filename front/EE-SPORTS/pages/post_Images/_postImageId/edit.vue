<template>
  <div>
    <form action @submit.prevent="handleSubmit">
      <input type="text" v-model="post_image.title" />
      <input type="text" v-model="post_image.caption" />
      <input type="submit" />
    </form>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      post_image: {}
    };
  },
  computed: {
    user() {
      return this.$store.state.user;
    }
  },
  methods: {
    async handleSubmit() {
      try {
        const res = await axios.post(
          `/edit/${this.$route.params.postImageId}`,
          this.post_image
        );
        this.$router.push(`/post_Images/${this.$route.params.postImageId}`);
        debugger;
      } catch (err) {
        console.log("post_err", err);
      }
    }
  },
  middleware: ["authenticated", "postUserAuth"],
  async created() {
    try {
      const res = await axios.get(
        `/post_image/${this.$route.params.postImageId}/edit`
      );
      this.post_image = res.data;
    } catch (err) {
      console.log("post_image_res_err", err);
    }
  }
};
</script>

<style>
</style>