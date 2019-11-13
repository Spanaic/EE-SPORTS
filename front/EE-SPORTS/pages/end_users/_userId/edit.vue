<template>
  <div>
    <form action @submit.prevent="hundleSubmit" enctype="multipart/form-data">
      <!-- <input type="text" v-model="end_user.email" /> -->
      <input type="text" v-model="end_user.name" />
      <input type="text" v-model="end_user.profile_name" />
      <img :src="`http://localhost:3001/end_users/${this.end_user.profile_image_name}`" alt />
      <!-- <input type="submit" /> -->

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
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      end_user: {},
      uploadedImage: "",
      img_name: "",
      files: [],
      itemLength: 0,
      loading: false
      //   caption: ""
    };
  },
  created() {
    var vm = this;
    var params = {
      TableName: "Faces"
    };
  },
  mounted() {
    axios
      .get(`/end_users/${this.$route.params.userId}`)
      .then(res => {
        console.log(res);
        this.end_user = res.data;
      })
      .catch(function(error) {
        console.log("ERROR!! occurred in Backend.", error);
      });
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
    hundleSubmit() {
      const formData = new FormData();
      var timestamp = new Date().getTime();
      var filename = "file" + timestamp + ".jpg";
      //   console.log(this.uploadFile);
      formData.append("end_user[image]", this.files[0]);
      formData.append("end_user[name]", this.end_user.name);
      formData.append("end_user[profile_image_name]", filename);
      formData.append("end_user[profile_name]", this.end_user.profile_name);
      //   formData.append("end_user[email", this.end_user.email);
      //   TODO:emailの変更を行う場合は、firebaseも一緒に変更しないとならない
      this.loading = true;
      var vm = this;
      console.log("----------------");
      console.log(...formData.entries());
      axios
        .put(
          `http://localhost:3001/end_users/${this.$route.params.userId}`,
          formData
        )
        .then(res => {
          console.log(res);
          this.$router.push({
            name: "end_users-id",
            params: { endUserId: res.data.id }
          });
        });
    }
  }
};
</script>

<style>
</style>