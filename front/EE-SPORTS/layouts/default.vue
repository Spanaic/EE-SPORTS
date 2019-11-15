<template>
  <v-app>
    <v-card class="overflow-hidden">
      <v-navigation-drawer
        v-model="drawer"
        :mini-variant="miniVariant"
        :clipped="clipped"
        fixed
        app
      >
        <v-list>
          <v-list-item v-for="(item, i) in items" :key="i" :to="item.to" router exact>
            <v-list-item-action>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title v-text="item.title" />
            </v-list-item-content>
          </v-list-item>
        </v-list>
        <!-- <v-list > -->

        <template v-slot:append>
          <div class="pa-2">
            <v-btn block @click.stop="drawer = !drawer">
              <v-text>Close</v-text>
            </v-btn>
          </div>
        </template>

        <!-- <v-col :justify="center">
          <v-btn @click.stop="drawer = !drawer">
        <!-- <v-icon>mdi-{{ `chevron-${miniVariant ? 'right' : 'left'}` }}</v-icon>-->
        <!-- <v-text>Close</v-text> -->
        <!-- </v-btn> -->
        <!-- </v-col> -->
        -->
        <!-- </v-list> -->
      </v-navigation-drawer>

      <v-app-bar
        :collapse="!collapseOnScroll"
        :collapse-on-scroll="collapseOnScroll"
        absolute
        color="deep-purple accent-4"
        dark
        scroll-target="#scrolling-techniques-6"
      >
        <v-app-bar-nav-icon @click.stop="drawer = !drawer" />

        <v-toolbar-title>Collapsing Bar</v-toolbar-title>

        <v-spacer></v-spacer>

        <v-form class="pt-4">
          <v-container>
            <v-text-field>
              <template v-slot:label>
                <strong>"#"</strong> or
                <strong>ユーザー名</strong>
                <v-icon style="vertical-align: middle">find_in_page</v-icon>
              </template>
            </v-text-field>
          </v-container>
        </v-form>
        <v-checkbox v-model="collapseOnScroll" color="white" hide-details></v-checkbox>
      </v-app-bar>

      <v-sheet id="scrolling-techniques-6" class="overflow-y-auto" max-height="1280">
        <v-parallax
          dark
          src="http://localhost:3001/performance-3110696_1920.jpg"
          height="100%"
          width="100%"
        >
          <v-container style="height: 100px;"></v-container>
          <!-- <v-content> -->
          <!-- <v-container> -->
          <nuxt />
          <!-- </v-container> -->
          <!-- </v-content> -->
          <v-footer :fixed="fixed" app>
            <span>&copy; 2019</span>
          </v-footer>
        </v-parallax>
      </v-sheet>
    </v-card>
  </v-app>
</template>

<script>
import { mdiLogout } from "@mdi/js";

export default {
  data() {
    return {
      collapseOnScroll: true,
      clipped: false,
      drawer: false,
      fixed: false,
      items: [
        {
          icon: "mdi-apps",
          title: "トップページ",
          to: "/post_Images"
        },
        {
          icon: "mdi-chart-bubble",
          title: "ユーザーリスト",
          to: "/end_users"
        },
        {
          icon: "mdi-chart-bubble",
          title: "新規投稿",
          to: "/post_images/new_post_image"
        },
        {
          icon: "mdi-chart-bubble",
          title: "新規登録",
          to: "/signUp"
        },
        {
          icon: "mdi-chart-bubble",
          title: "ログイン",
          to: "/login"
        },
        {
          icon: "mdi-chart-bubble",
          title: "マイページ",
          to: "/end_users/" + `${this.$store.state.user.id}`
        }
      ],
      miniVariant: false,
      right: true,
      rightDrawer: false,
      title: "Vuetify.js"
    };
    consol.log(this);
  },
  methods: {
    logOut() {
      this.$store.dispatch("logOut");
      this.$router.go("/post_images");
    }
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    }
  }
};
</script>

<style>
</style>