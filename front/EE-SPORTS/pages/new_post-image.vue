<template>
  <div class="contents">
    <form action="
 " @submit.prevent="handleSubmit" enctype="multipart/form-data">
      <label v-show="!uploadedImage" class="input-item__label">画像を選択</label>
      <input type="file" @change="onFileChange" />
      <div class="preview-item">
        <img v-show="uploadedImage" class="preview-item-file" :src="uploadedImage" alt />
        <div v-show="uploadedImage" class="preview-item-btn" @click="remove">
          <p class="preview-item-name">{{ img_name }}</p>
        </div>
      </div>
      <input type="submit" id="apply-upload" v-show="uploadedImage" />
    </form>
    <div v-if="loading"></div>
  </div>
</template>

<script>
import axios from "axios";

export default {
  components: {},
  data() {
    return {
      uploadedImage: "",
      img_name: "",
      files: [],
      itemLength: 0,
      loading: false
    };
  },
  middleware: "authenticated",
  created() {
    var vm = this;
    var params = {
      TableName: "Faces"
    };
  },
  async mounted() {
    console.log("notificationsCheck", this.$store.state.user);
    await this.$store.dispatch("notificationsCheck", this.$store.state.user);
  },
  methods: {
    onFileChange(e) {
      console.log(e);
      const files = e.target.files;
      this.createImage(files[0]);
      console.log(files[0]);
      this.files = files;
      this.img_name = files[0].name;
    },
    // アップロードした画像を表示
    createImage(file) {
      const reader = new FileReader();
      console.log(reader);
      reader.onload = e => {
        console.log(e);
        this.uploadedImage = e.target.result;
      };
      reader.readAsDataURL(file);
    },
    remove() {
      this.uploadedImage = false;
    },
    handleSubmit() {
      const formData = new FormData();
      var timestamp = new Date().getTime();
      var filename = "file" + timestamp + ".jpg";
      console.log(this.uploadFile);
      formData.append("post_image[image]", this.files[0]);
      this.loading = true;
      var vm = this;
      //   axios.get("http://localhost:3001/post_images.json").then(res => {
      //     console.log(res.data);
      //   });
      axios.post("http://localhost:3001/post_images", formData);
    }
  }
};
</script>
<style lang="scss">
.preview-item {
  width: 500px;
  height: 500px;
  img {
    width: 100%;
    height: 100%;
  }
}
</style>