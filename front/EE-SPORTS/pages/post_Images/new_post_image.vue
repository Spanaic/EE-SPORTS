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
        <v-btn>Signup</v-btn>
      </v-card-actions>

      <v-col cols="12" :justify="justify-center">
        <v-btn class="btn" round outline color="primary" dark>
          <input type="submit" id="apply-upload" />
        </v-btn>
      </v-col>
    </form>

    <v-card-actions>
      <v-list-item class="grow">
        <v-list-item-avatar color="grey darken-3">
          <v-img
            class="elevation-6"
            src="https://avataaars.io/?avatarStyle=Transparent&topType=ShortHairShortCurly&accessoriesType=Prescription02&hairColor=Black&facialHairType=Blank&clotheType=Hoodie&clotheColor=White&eyeType=Default&eyebrowType=DefaultNatural&mouthType=Default&skinColor=Light"
          ></v-img>
        </v-list-item-avatar>

        <v-list-item-content>
          <v-list-item-title>Evan You</v-list-item-title>
        </v-list-item-content>

        <v-row align="center" justify="end">
          <v-icon class="mr-1">mdi-heart</v-icon>
          <span class="subheading mr-2">256</span>
          <span class="mr-1">·</span>
          <v-icon class="mr-1">mdi-share-variant</v-icon>
          <span class="subheading">45</span>
        </v-row>
      </v-list-item>
    </v-card-actions>
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
  //   fetch() {},
  methods: {
    onFileChange(e) {
      console.log(e);
      // const files = e.target.files;

      // console.log("-------------");
      // console.log(e.target.files);
      // console.log("-------------");

      this.createImage(e);
      // console.log(files[0]);
      this.file = e;
      this.img_name = e.name;
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
      formData.append("post_image[image]", this.file);
      formData.append("post_image[caption]", this.caption);
      formData.append("post_image[title]", this.title);
      formData.append("post_image[image_name]", filename);
      // formData.append("post_image[image_name]", img_name);
      formData.append("post_image[end_user_id]", this.$store.state.user.id);
      // formData.append("post_image[image]", this.caption);
      this.loading = true;
      var vm = this;
      //   axios.get("http://localhost:3001/post_images.json").then(res => {
      //     console.log(res.data);
      //   });
      console.log("----------------");
      console.log(formData);
      // const data = {
      //   caption: this.caption,
      //   name: filename
      // };
      axios.post("http://localhost:3001/post_images", formData).then(res => {
        // console.log(res);
        this.$router.push(`/post_Images/${res.data.id}`);
        // .catch(err) = {
        //   alert(err)
        // }
        // this.$router.push({
        //   name: "post_Images-id",
        //   params: { postImageId: res.data.id }
        // });
      });
    }
  }
};
// export default {
//   components: {},
//   data() {
//     return {
//       uploadedImage: "",
//       img_name: "",
//       files: [],
//       itemLength: 0,
//       loading: false,
//       caption: ""
//     };
//   },
//   created() {
//     var vm = this;
//     var params = {
//       TableName: "Faces"
//     };
//   },
//   //   fetch() {},
//   methods: {
//     onFileChange(e) {
//       console.log(e);
//       const files = e.target.files;
//       this.createImage(files[0]);
//       console.log(files[0]);
//       this.files = files;
//       this.img_name = files[0].name;
//     },
//     // アップロードした画像を表示
//     createImage(file) {
//       const reader = new FileReader();
//       console.log(reader);
//       reader.onload = e => {
//         console.log(e);
//         this.uploadedImage = e.target.result;
//       };
//       reader.readAsDataURL(file);
//     },
//     remove() {
//       this.uploadedImage = false;
//     },
//     handleSubmit() {
//       const formData = new FormData();
//       var timestamp = new Date().getTime();
//       var filename = "file" + timestamp + ".jpg";
//       console.log(this.uploadFile);
//       formData.append("post_image[image]", this.files[0]);
//       this.loading = true;
//       var vm = this;
//       //   axios.get("http://localhost:3001/post_images.json").then(res => {
//       //     console.log(res.data);
//       //   });
//       console.log(formData);
//       axios.post("http://localhost:3001/post_images", formData);
//     }
//   }
// };
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