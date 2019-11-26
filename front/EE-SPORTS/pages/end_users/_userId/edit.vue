l<template>
  <div>
    <!-- <v-card class="mx-auto" color="#26c6da" dark max-width="400">
      <v-card-title>
        <v-icon large left>mdi-draw</v-icon>
        <span class="title font-weight-light">新規登録</span>
      </v-card-title>
      <form action>
        <v-text-field
          class="ma-5"
          v-model="email"
          :error-messages="emailErrors"
          label="Email"
          required
          @input="$v.email.$touch()"
          @blur="$v.email.$touch()"
        ></v-text-field>
        <v-text-field
          class="ma-5"
          v-model="password"
          :error-messages="passwordErrors"
          label="パスワード"
          required
          @input="$v.password.$touch()"
          @blur="$v.password.$touch()"
        ></v-text-field>
        <v-text-field
          class="ma-5"
          v-model="name"
          :error-messages="nameErrors"
          :counter="20"
          label="お名前"
          required
          @input="$v.name.$touch()"
          @blur="$v.name.$touch()"
        ></v-text-field>
        <v-text-field
          class="ma-5"
          v-model="profile_name"
          :error-messages="profileNameErrors"
          :counter="50"
          label="ユーザー名"
          required
          @input="$v.profile_name.$touch()"
          @blur="$v.profile_name.$touch()"
        ></v-text-field>

        <v-card-actions class="justify-center">
          <v-btn class="btn" @click="submit" color="primary" dark>新規登録</v-btn>
          <v-btn @click="testLogIn">テストユーザーで簡単ログイン</v-btn>
        </v-card-actions>
      </form>
    </v-card>

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
    </v-card>-->

    <!-- <form action @submit.prevent="handleSubmit" enctype="multipart/form-data">
      <input type="text" v-model="end_user.name" />
      <input type="text" v-model="end_user.profile_name" />
      <img :src="`http://localhost:3001/end_users/${this.end_user.profile_image_name}`" alt />

      <label v-show="!uploadedImage" class="input-item__label">画像を選択</label>
      <input type="file" @change="onFileChange" />

      <div class="preview-item">
        <img v-show="uploadedImage" class="preview-item-file" :src="uploadedImage" alt />
        <div v-show="uploadedImage" class="preview-item-btn" @click="remove">
          <p class="preview-item-name">{{ img_name }}</p>
        </div>
      </div>
      <input type="submit" id="apply-upload" v-show="uploadedImage" />
    </form>-->

    <v-card class="mx-auto" color="#26c6da" dark max-width="400">
      <v-card-title>
        <v-icon large left>mdi-folder-upload-outline</v-icon>
        <span class="title font-weight-light">新規投稿</span>
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
        <!-- <label v-show="!uploadedImage" class="input-item__label">画像を選択</label> -->

        <v-file-input label="プロフィール画像をアップロード" outlined dense @change="onFileChange"></v-file-input>

        <!-- <label v-show="!uploadedImage" class="input-item__label">画像を選択</label>
        <input type="file" @change="onFileChange" />-->

        <!-- <v-btn class="mr-4">
          <input type="submit" id="apply-upload" />
        </v-btn>-->

        <!-- <v-btn @click="clear">clear</v-btn> -->
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

export default {
  mixins: [validationMixin],
  validations: {
    name: { maxLength: maxLength(30) },
    profile_name: { required, maxLength: maxLength(50) }
  },
  data() {
    return {
      end_user: {},
      uploadedImage: "",
      img_name: "",
      file: null,
      itemLength: 0,
      loading: false
      // name: "",
      // profile_name: ""
    };
  },
  computed: {
    nameErrors() {
      // const errors = [];
      // if (!this.$v.name.$dirty) return errors;
      // !this.$v.name.maxLength &&
      //   errors.push("名前は30文字以内で入力して下さい");
      // !this.$v.name.required && errors.push("名前は入力必須です");
      // return errors;
    },
    profileNameErrors() {
      // const errors = [];
      // if (!this.$v.profile_name.$dirty) return errors;
      // // !this.$v.profile_name.maxLength &&
      // //   errors.push("ユーザー名は50以内で入力して下さい");
      // !this.$v.profile_name.required && errors.push("ユーザー名は入力必須です");
      // return errors;
    }
  },
  middleware: ["authenticated", "userAuth"],
  created() {
    // if (this.$route.params.userId !== this.$store.state.user.id) {
    //   this.$router.push(`/end_users/${this.$store.state.user.id}`);
    var vm = this;
    var params = {
      TableName: "Faces"
    };
    // }
    // axios
    //   .get(`/end_users/${this.$route.params.userId}`)
    //   .then(res => {
    //     this.end_user = res.data;
    //     this.$store.dispatch("notificationsCheck", this.$store.state.user);
    //   })
    //   .catch(function(error) {
    //     console.log("ERROR!! occurred in Backend.", error);
    //   });
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
    // if (this.end_user.id !== this.$store.state.user.id) {
    //   this.$router.push(`/end_users/${this.$store.state.user.id}`);
    // }
  },
  methods: {
    onFileChange(e) {
      // const files = e.target.files;
      this.createImage(e);
      this.file = e;
      this.img_name = e.name;
    },
    // アップロードした画像を表示
    createImage(file) {
      const reader = new FileReader();
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
      //   console.log(this.uploadFile);
      formData.append("end_user[image]", this.file);
      formData.append("end_user[name]", this.end_user.name);
      formData.append("end_user[profile_image_name]", filename);
      formData.append("end_user[profile_name]", this.end_user.profile_name);
      //   formData.append("end_user[email", this.end_user.email);
      //   TODO:emailの変更を行う場合は、firebaseも一緒に変更しないとならない
      this.loading = true;
      var vm = this;
      axios
        .put(
          `http://localhost:3001/end_users/${this.$route.params.userId}`,
          formData
        )
        .then(res => {
          this.$router.push(
            `/end_users/${this.$route.params.userId}`,
            this.$store.state.user
          );
          // this.$router.push({
          //   name: "end_users-id",
          //   params: { id: res.data.id }
          // });
        });
    }
  }
  // asyncData() {
  //   axios
  //     .get(`/end_users/${this.$route.params.userId}`)
  //     .then(res => {
  //       this.end_user = res.data;
  //     })
  //     .catch(function(error) {
  //       console.log("ERROR!! occurred in Backend.", error);
  //     });
  // }
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