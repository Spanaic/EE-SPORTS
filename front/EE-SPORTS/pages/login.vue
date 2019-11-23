 <template>
  <div>
    <!-- <v-container>
      <v-layout row class="text-xs-center">
        <v-flex xs3 style="background-image: url('http://cdn.wallpapersafari.com/7/86/gqiGH7.jpg')">
          <v-card height="500px"></v-card>
        </v-flex>
        <v-flex xs4 class="grey lighten-4">
          <v-container style="position: relative;top: 13%;" class="text-xs-center">
            <v-card flat>
              <v-card-title primary-title>
                <h4>Login</h4>
              </v-card-title>
              <v-form>
                <v-text-field prepend-icon="person" name="Username" label="Username"></v-text-field>
                <v-text-field prepend-icon="lock" name="Password" label="Password" type="password"></v-text-field>
                <v-card-actions>
                  <v-btn primary large block>Login</v-btn>
                </v-card-actions>
              </v-form>
            </v-card>
          </v-container>
        </v-flex>
      </v-layout>
    </v-container>-->

    <v-card class="pa-5 mt-5">
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
    </v-card>
  </div>
</template>

<script>
import { validationMixin } from "vuelidate";
import { required, email, minLength } from "vuelidate/lib/validators";
import firebase from "@/plugins/firebase";
import axios from "@/plugins/axios";

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