 <template>
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
    </form>
  </v-card>
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
    password: ""
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
      // this.email = "";
      // this.password = "";
      // this.name = "";
      // this.profile_name = "";
    }
  }
};
</script>