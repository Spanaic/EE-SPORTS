<template>
  <v-container>
    <v-layout justify-center>
      <v-flex xs12 sm8>
        <v-toolbar color="primary" dark>
          <v-toolbar-title>ログイン</v-toolbar-title>
        </v-toolbar>

        <v-card>
          <v-container fluid>
            <v-form ref="form">
              <v-layout row wrap>
                <v-text-field
                  type="email"
                  v-model="$v.email.$model"
                  label="メールアドレス"
                  required
                  :error-messages="emailErrors"
                ></v-text-field>
              </v-layout>

              <v-layout row wrap>
                <v-text-field
                  type="password"
                  v-model="$v.password.$model"
                  label="パスワード"
                  required
                  :error-messages="passwordErrors"
                ></v-text-field>
              </v-layout>

              <v-layout row wrap justify-center>
                <v-btn block color="success" @click="signIn()">ログイン</v-btn>
              </v-layout>
            </v-form>
          </v-container>
        </v-card>
      </v-flex>
    </v-layout>
  </v-container>
</template>

<script>
import { required, email } from "vuelidate/lib/validators";
import { validateEmail, validatePassword } from "@/plugins/validations";
// import { validationMixin } from "vuelidate";
export default {
  head() {
    return {
      title: "ログイン"
    };
  },

  data: () => ({
    email: "",
    password: ""
  }),

  validations: {
    email: {
      required,
      email
    },
    password: {
      required
    }
  },

  computed: {
    emailErrors() {
      console.log(this.$v);
      return validateEmail(this.$v.email);
    },

    passwordErrors() {
      return validatePassword(this.$v.password);
    }
  },

  methods: {
    async signIn() {
      // validation発火
      this.$v.$touch();
      // validationに引っかかってるか検査
      if (this.$v.$invalid) return;
      // このあとサインイン処理
    }
  }
};
</script>