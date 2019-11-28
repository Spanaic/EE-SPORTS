l<template>
  <div>
    <v-card class="mx-auto" color="#26c6da" dark max-width="400">
      <v-card-title>
        <v-icon large left>mdi-account-edit</v-icon>
        <span class="title font-weight-light">プロフィール編集</span>
      </v-card-title>
      <form @submit.prevent="handleSubmit" enctype="multipart/form-data">
        <v-text-field
          class="ma-5"
          v-model="end_user.name"
          :error-messages="nameErrors"
          :counter="30"
          label="名前"
          required
          @input="$v.name.$touch()"
          @blur="$v.name.$touch()"
        ></v-text-field>
        <v-text-field
          class="ma-5"
          v-model="end_user.profile_name"
          :error-messages="profileNameErrors"
          :counter="300"
          label="ユーザー名"
          required
          @input="$v.profile_name.$touch()"
          @blur="$v.profile_name.$touch()"
        ></v-text-field>

        <v-file-input class="ma-5" label="プロフィール画像をアップロード" outlined dense @change="onFileChange"></v-file-input>

        <v-card-actions class="justify-center">
          <v-btn class="btn" color="primary" dark>
            <input type="submit" id="apply-upload" />
          </v-btn>
        </v-card-actions>
      </form>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import { validationMixin } from "vuelidate";
import { required, maxLength } from "vuelidate/lib/validators";
import firebase from "@/plugins/firebase";
import { mdiAccountEdit } from "@mdi/js";

export default {
  mixins: [validationMixin],
  validations: {
    name: { maxLength: maxLength(30) },
    profile_name: { required, maxLength: maxLength(50) }
  },
  data() {
    return {
      baseUrl: process.env.BASE_URL,
      end_user: {},
      uploadedImage: "",
      img_name: "",
      file: null,
      itemLength: 0,
      loading: false
    };
  },
  computed: {
    nameErrors() {},
    profileNameErrors() {}
  },
  middleware: ["authenticated", "userAuth"],
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
        if (res.data.id !== this.$store.state.user.id) {
          this.$router.push(`/end_users/${this.$store.state.user.id}`);
        }
        this.end_user = res.data;
        this.$store.dispatch("notificationsCheck", this.$store.state.user);
      })
      .catch(function(error) {
        console.log("ERROR!! occurred in Backend.", error);
      });
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
      formData.append("end_user[image]", this.file);
      formData.append("end_user[name]", this.end_user.name);
      formData.append("end_user[profile_image_name]", filename);
      formData.append("end_user[profile_name]", this.end_user.profile_name);
      this.loading = true;
      var vm = this;
      axios
        .put(`${this.baseUrl}/end_users/${this.$route.params.userId}`, formData)
        .then(res => {
          this.$router.push(
            `/end_users/${this.$route.params.userId}`,
            this.$store.state.user
          );
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