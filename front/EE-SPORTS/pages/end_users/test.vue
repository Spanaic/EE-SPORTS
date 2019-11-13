 <template>
  <v-card class="pa-5">
    <!-- <form action="create" @submit.prevent="hundleSubmit"> -->
    <form action>
      <v-text-field
        v-model="email"
        :error-messages="emailErrors"
        :counter="50"
        label="Email"
        required
        @input="$v.email.$touch()"
        @blur="$v.email.$touch()"
      ></v-text-field>
      <v-text-field
        v-model="password"
        :error-messages="passwordErrors"
        label="お名前"
        required
        @input="$v.password.$touch()"
        @blur="$v.password.$touch()"
      ></v-text-field>
      <v-text-field
        v-model="name"
        :error-messages="nameErrors"
        label="お名前"
        required
        @input="$v.name.$touch()"
        @blur="$v.name.$touch()"
      ></v-text-field>
      <v-text-field
        v-model="profile_name"
        :error-messages="profileNameErrors"
        label="ユーザー名"
        required
        @input="$v.profile_name.$touch()"
        @blur="$v.profile_name.$touch()"
      ></v-text-field>

      <!-- <v-select
        v-model="select"
        :items="items"
        :error-messages="selectErrors"
        label="Item"
        required
        @change="$v.select.$touch()"
        @blur="$v.select.$touch()"
      ></v-select>
      <v-checkbox
        v-model="checkbox"
        :error-messages="checkboxErrors"
        label="Do you agree?"
        required
        @change="$v.checkbox.$touch()"
        @blur="$v.checkbox.$touch()"
      ></v-checkbox>-->

      <v-btn class="mr-4" @click="submit">submit</v-btn>
      <v-btn @click="clear">clear</v-btn>
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
// import axios from "axios";
import axios from "@/plugins/axios";

export default {
  mixins: [validationMixin],

  validations: {
    name: { required, maxLength: maxLength(10) },
    profile_name: { required, maxLength: maxLength(50) },
    email: { required, email },
    password: { required, minLength: minLength(6) }
    // select: { required },
    // checkbox: {
    //   checked(val) {
    //     return val;
    //   }
    // }
  },

  data: () => ({
    name: "",
    email: "",
    profile_name: "",
    password: ""
    // select: null,
    // items: ["Item 1", "Item 2", "Item 3", "Item 4"],
    // checkbox: false
  }),

  computed: {
    // checkboxErrors() {
    //   const errors = [];
    //   if (!this.$v.checkbox.$dirty) return errors;
    //   !this.$v.checkbox.checked && errors.push("You must agree to continue!");
    //   return errors;
    // },
    // selectErrors() {
    //   const errors = [];
    //   if (!this.$v.select.$dirty) return errors;
    //   !this.$v.select.required && errors.push("Item is required");
    //   return errors;
    // },
    nameErrors() {
      const errors = [];
      if (!this.$v.name.$dirty) return errors;
      !this.$v.name.maxLength &&
        errors.push("お名前は10文字以内で入力して下さい");
      // errors.push("Name must be at most 50 characters long");
      !this.$v.name.required && errors.push("お名前は入力必須です");
      //   !this.$v.name.required && errors.push("Name is required.");
      return errors;
    },
    emailErrors() {
      const errors = [];
      if (!this.$v.email.$dirty) return errors;
      //   !this.$v.email.email && errors.push("Must be valid e-mail");
      !this.$v.email.email &&
        errors.push("正しいEmailアドレスを入力して下さい");
      //   !this.$v.email.required && errors.push("E-mail is required");
      !this.$v.email.required && errors.push("Emailは入力必須です");
      return errors;
    },
    profileNameErrors() {
      const errors = [];
      if (!this.$v.profile_name.$dirty) return errors;
      !this.$v.profiel_name.maxLength &&
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

  methods: {
    submit() {
      this.$v.$touch();
    },
    clear() {
      this.$v.$reset();
      this.name = "";
      this.email = "";
      this.profile_name = "";
      this.password = "";
      //   this.select = null;
      //   this.checkbox = false;
    }
  }
};
</script>