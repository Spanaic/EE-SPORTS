<template>
  <v-card class="mx-auto" color="#26c6da" dark max-width="400">
    <v-card-title>
      <v-icon large left>mdi-folder-upload-outline</v-icon>
      <span class="title font-weight-light">新規投稿</span>
    </v-card-title>
    <form @submit.prevent="handleSubmit" enctype="multipart/form-data">
      <v-text-field
        class="ma-5"
        v-model="title"
        :error-messages="titleErrors"
        :counter="30"
        label="title"
        required
        @input="$v.title.$touch()"
        @blur="$v.title.$touch()"
      ></v-text-field>
      <v-text-field
        class="ma-5"
        v-model="caption"
        :error-messages="captionErrors"
        :counter="300"
        label="caption"
        required
        @input="$v.caption.$touch()"
        @blur="$v.caption.$touch()"
      ></v-text-field>
      <v-file-input class="ma-5" label="File input" outlined dense @change="onFileChange"></v-file-input>

      <v-card-actions class="justify-center">
        <v-btn class="btn" color="primary" dark>
          <input type="submit" id="apply-upload" />
        </v-btn>
      </v-card-actions>
    </form>
  </v-card>
</template>

<script>
import { validationMixin } from "vuelidate";
import { required, maxLength, minLength } from "vuelidate/lib/validators";
import firebase from "@/plugins/firebase";
import axios from "@/plugins/axios";
import { mdiFolderUploadOutline } from "@mdi/js";

export default {
  mixins: [validationMixin],

  validations: {
    title: { required, maxLength: maxLength(30) },
    caption: { required, maxLength: maxLength(300) }
  },

  data() {
    return {
      uploadedImage: "",
      img_name: "",
      file: null,
      itemLength: 0,
      loading: false,
      caption: "",
      title: ""
    };
  },

  computed: {
    titleErrors() {
      const errors = [];
      if (!this.$v.title.$dirty) return errors;
      !this.$v.title.maxLength &&
        errors.push("タイトルは30文字以内で入力して下さい");
      !this.$v.title.required && errors.push("タイトルは入力必須です");
      return errors;
    },
    captionErrors() {
      const errors = [];
      if (!this.$v.caption.$dirty) return errors;
      !this.$v.caption.maxLength &&
        errors.push("本文は300文字以内で入力して下さい");
      !this.$v.caption.required && errors.push("本文は入力必須です");
      return errors;
    }
  },

  created() {
    var vm = this;
    var params = {
      TableName: "Faces"
    };
  },
  async mounted() {
    await this.$store.dispatch("notificationsCheck", this.$store.state.user);
  },
  methods: {
    onFileChange(e) {
      this.createImage(e);
      this.file = e;
      this.img_name = e.name;
    },
    createImage(file) {
      const reader = new FileReader();
      reader.onload = e => {
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
      formData.append("post_image[image]", this.file);
      formData.append("post_image[caption]", this.caption);
      formData.append("post_image[title]", this.title);
      formData.append("post_image[image_name]", filename);
      formData.append("post_image[end_user_id]", this.$store.state.user.id);
      this.loading = true;
      var vm = this;
      axios.post("http://localhost:3001/post_images", formData).then(res => {
        this.$router.push(`/post_Images/${res.data.id}`);
      });
    }
  }
};
</script>
<style lang="scss" scoped>
.preview-item {
  width: 500px;
  height: 500px;
  img {
    width: 100%;
    height: 100%;
  }
}
</style>