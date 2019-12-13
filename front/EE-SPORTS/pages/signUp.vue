 <template>
  <v-card class="mx-auto" color="#26A69A" dark max-width="400">
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
        :type="'password'"
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
</template>

<script>
import { validationMixin } from "vuelidate";
import {
  required,
  maxLength,
  email,
  minLength
} from "vuelidate/lib/validators";
import firebase from "@/plugins/firebase";
import axios from "@/plugins/axios";
import { mdiDraw } from "@mdi/js";

export default {
  mixins: [validationMixin],

  validations: {
    name: { required, maxLength: maxLength(20) },
    profile_name: { required, maxLength: maxLength(50) },
    email: { required, email },
    password: { required, minLength: minLength(6) }
  },

  data: () => ({
    name: "",
    email: "",
    profile_name: "",
    password: "",
    test_email: "test@gmail.com",
    test_password: "password"
  }),
  mounted() {
    console.log({ axios });
    console.log(process.env.BASE_URL);
  },

  computed: {
    nameErrors() {
      const errors = [];
      if (!this.$v.name.$dirty) return errors;
      !this.$v.name.maxLength &&
        errors.push("お名前は20文字以内で入力して下さい");
      !this.$v.name.required && errors.push("お名前は入力必須です");
      return errors;
    },
    emailErrors() {
      const errors = [];
      if (!this.$v.email.$dirty) return errors;
      !this.$v.email.email &&
        errors.push("正しいEmailアドレスを入力して下さい");
      !this.$v.email.required && errors.push("Emailは入力必須です");
      return errors;
    },
    profileNameErrors() {
      const errors = [];
      if (!this.$v.profile_name.$dirty) return errors;
      !this.$v.profile_name.maxLength &&
        errors.push("ユーザー名は50文字以内で入力して下さい");
      !this.$v.email.required && errors.push("ユーザー名は入力必須です");
      return errors;
    },
    passwordErrors() {
      const errors = [];
      if (!this.$v.password.$dirty) return errors;
      !this.$v.password.minLength &&
        errors.push("パスワードは6文字以上で入力して下さい");
      !this.$v.password.required && errors.push("パスワードは入力必須です");
      return errors;
    }
  },

  // middleware: "loginUser",

  methods: {
    submit() {
      this.$store.dispatch("signUp", [
        this.email,
        this.password,
        this.name,
        this.profile_name
      ]);
    },
    testLogIn() {
      this.$store.dispatch("testLogIn", [this.test_email, this.test_password]);
      this.$router.push("/post_Images");
    }
  }
};
</script>