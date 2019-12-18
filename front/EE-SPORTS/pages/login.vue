 <template>
  <div>
    <v-card class="mx-auto" color="#7CB342" dark max-width="400">
      <v-card-title>
        <v-icon large left>mdi-login</v-icon>
        <span class="title font-weight-light">ログイン</span>
      </v-card-title>
      <form @submit.prevent="handleSubmit" enctype="multipart/form-data">
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
          :type="'password'"
          @input="$v.password.$touch()"
          @blur="$v.password.$touch()"
        ></v-text-field>

        <v-card-actions class="justify-center">
          <v-btn class="btn" @click="submit" color="primary" dark>ログイン</v-btn>
          <v-btn @click="testLogIn">テストユーザーで簡単ログイン</v-btn>
        </v-card-actions>
      </form>
    </v-card>
  </div>
</template>

<script>
import { validationMixin } from "vuelidate";
import { required, email, minLength } from "vuelidate/lib/validators";
import firebase from "@/plugins/firebase";
import axios from "@/plugins/axios";
import { mdiLogin } from "@mdi/js";

export default {
  mixins: [validationMixin],

  validations: {
    email: { required, email },
    password: { required, minLength: minLength(6) }
  },

  data: () => ({
    email: "",
    password: "",
    test_email: "test@gmail.com",
    test_password: "password",
    base_url: process.env.BASE_URL
  }),
  created() {
    console.log("process.env.BASE_URL", process.env.BASE_URL);
    console.log("process.env.API_KEY", process.env.API_KEY);
  },
  computed: {
    emailErrors() {
      const errors = [];
      if (!this.$v.email.$dirty) return errors;
      !this.$v.email.email &&
        errors.push("正しいEmailアドレスを入力して下さい");
      !this.$v.email.required && errors.push("Emailは入力必須です");
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
  middleware: "loginUser", //ログイン済みユーザーはredirect
  methods: {
    submit() {
      this.$store.dispatch("logIn", [this.email, this.password]);
    },
    testLogIn() {
      this.$store.dispatch("testLogIn", [this.test_email, this.test_password]);
    }
  }
};
</script>