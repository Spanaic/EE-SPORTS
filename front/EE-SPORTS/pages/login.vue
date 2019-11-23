 <template>
  <div>
    <v-card class="mx-auto" color="#26c6da" dark max-width="400">
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
          @input="$v.password.$touch()"
          @blur="$v.password.$touch()"
        ></v-text-field>

        <v-card-actions class="justify-center">
          <v-btn class="btn" @click="submit" color="primary" dark>
            ログイン
          </v-btn>
          <v-btn @click="testLogIn">テストユーザーで簡単ログイン</v-btn>
        </v-card-actions>
      </form>
    </v-card>

    <!-- <v-card class="pa-5 mt-5">
      <form action>
        <v-text-field
          v-model="email"
          :error-messages="emailErrors"
          label="Email"
          required
          @input="$v.email.$touch()"
          @blur="$v.email.$touch()"
        ></v-text-field>
        <v-text-field
          v-model="password"
          :error-messages="passwordErrors"
          label="パスワード"
          required
          @input="$v.password.$touch()"
          @blur="$v.password.$touch()"
        ></v-text-field>

        <v-btn class="mr-4" @click="submit">submit</v-btn>
        <v-btn @click="clear">clear</v-btn>
        <v-btn @click="testLogIn">テストユーザーで簡単ログイン</v-btn>
      </form>
    </v-card> -->
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
    test_password: "password"
  }),

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

  methods: {
    submit() {
      this.$store.dispatch("logIn", [this.email, this.password]);
      // this.$router.push("/post_Images");

      // this.email = "";
      // this.password = "";
      // this.name = "";
      // this.profile_name = "";
    },
    testLogIn() {
      this.$store.dispatch("testLogIn", [this.test_email, this.test_password]);
      // this.$router.push("/post_Images");
    }
  }
};

// import firebase from "@/plugins/firebase";
// import axios from "axios";

// export default {
//   data() {
//     return {
//       email: "",
//       password: "",
//       error: "",
//       error_checker: false
//     };
//   },
//   mounted() {
//     // console.log(firebase.auth().currentUser);
//   },
//   methods: {
//     hundleSubmit() {
//       this.$store.dispatch("logIn", [this.email, this.password]);
//       //   var provider = new firebase.auth.GoogleAuthProvider();
//       //   firebase.auth().signInWithPopup(provider);
//       // firebase
//       //   .auth()
//       //   .createUserWithEmailAndPassword(this.email, this.password)
//       //   .then(user => {
//       //     console.log(user.user.email);
//       //     axios.post("http://localhost:3001/users", {
//       //       email: this.email
//       //     });
//       //     this.email = "";
//       //     this.password = "";
//       //     console.log("Sign-out successful.");
//       //     this.$router.push("/");
//       //   })
//       //   .catch(err => {
//       //     this.error = err.message;
//       //     this.error_checker = true;
//       //     console.log(this.error_checker);
//       //   });
//     },
//     logOut() {
//       this.$store.dispatch("logOut");
//       // firebase
//       //   .auth()
//       //   .signOut()
//       //   .then(function() {
//       //     console.log("Sign-out successful.");
//       //   })
//       //   .catch(function(error) {
//       //     console.log("An error happened.");
//       //   });
//     },
//     googleLogIn() {
//       // var provider = new firebase.auth.GoogleAuthProvider();
//       // firebase
//       //   .auth()
//       //   .signInWithPopup(provider)
//       //   .then(res => {
//       //     console.log("Sign-in successful.");
//       //   });
//       this.$store.dispatch("logInGoogle", [this.email, this.name]);
//     }
//   }
// };
</script>