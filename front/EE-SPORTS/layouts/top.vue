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
          <v-list-item
            v-for="(item, i) in items"
            :key="i"
            :to="item.to"
            router
            exact
            @click.stop="drawer = !drawer"
          >
            <v-list-item-action>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-item-action>
            <v-list-item-content>
              <v-list-item-title v-text="item.title" />
            </v-list-item-content>
          </v-list-item>
        </v-list>

        <template v-slot:append>
          <div class="pa-2">
            <v-btn block @click.stop="drawer = !drawer">
              <v-text>Close</v-text>
            </v-btn>
          </div>
        </template>
      </v-navigation-drawer>

      <v-app-bar
        :collapse="!collapseOnScroll"
        :collapse-on-scroll="collapseOnScroll"
        absolute
        color="cyan darken-1"
        dark
        scroll-target="#scrolling-techniques-6"
      >
        <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
        <nuxt-link to="/post_Images">
          <v-toolbar-title>
            <v-img :src="`${baseUrl}/EE!Sports_logo.png`" height="100" width="100" class="mt-5"></v-img>
          </v-toolbar-title>
        </nuxt-link>

        <v-spacer></v-spacer>

        <notifications />

        <v-form @submit.prevent="searchSubmit" class="pt-5">
          <v-container>
            <v-text-field v-model="keyword">
              <template v-slot:label>
                <strong>"#"</strong> or
                <strong>画像タイトル</strong>
                <v-icon style="vertical-align: middle">find_in_page</v-icon>
              </template>
            </v-text-field>
          </v-container>
        </v-form>
        <v-checkbox v-model="collapseOnScroll" color="white" hide-details></v-checkbox>
      </v-app-bar>

      <v-sheet id="scrolling-techniques-6" class="overflow-y-auto" max-height="1280">
        <div class="bg">
          <v-container style="height: 100px;"></v-container>
          <nuxt />
        </div>

        <v-footer :fixed="fixed" app>
          <v-btn icon @click="logOut" :right="right">
            <v-icon>mdi-logout</v-icon>
          </v-btn>
          <span>&copy; 2019</span>
        </v-footer>
      </v-sheet>
    </v-card>
  </v-app>
</template>

<script>
import { mdiLogout } from "@mdi/js";
import { mdiBell } from "@mdi/js";
import axios from "@/plugins/axios";
import Notifications from "@/components/Notifications";

export default {
  components: {
    Notifications
  },
  data() {
    return {
      baseUrl: process.env.baseUrl,
      collapseOnScroll: true,
      clipped: false,
      drawer: false,
      fixed: false,

      miniVariant: false,
      right: true,
      rightDrawer: false,
      title: "Vuetify.js",

      // notificationのbadge用
      bottom: false,
      color: "primary",
      colors: [
        "primary",
        "accent",
        "warning lighten-2",
        "teal",
        "error lighten-2"
      ],
      left: false,
      overlap: true,
      user: this.$store.state.user,

      // notification/badge
      show: false,
      messages: 0,

      // notification_list
      notifications: [],

      // 検索結果
      keyword: "",
      searchResults: []
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    },
    items() {
      if (this.currentUser.id) {
        return [
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
            title: "マイページ",
            to: "/end_users/" + `${this.currentUser.id}`
          }
        ];
      } else {
        return [
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
            title: "新規登録",
            to: "/signUp"
          },
          {
            icon: "mdi-chart-bubble",
            title: "ログイン",
            to: "/login"
          }
        ];
      }
    }
  },
  created() {
    const unwatch = this.$store.watch(
      state => state.user,
      async (newUser, oldUser) => {
        if (newUser.id) {
          try {
            const res = await axios.get(`/notifications/${newUser.id}`);
            this.notifications = res.data.filter(notification => {
              return notification.checked === false;
            });
          } catch (err) {
            console.log("Notifications err", err);
            return null;
          }
          unwatch();
        }
      }
    );
  },
  methods: {
    logOut() {
      this.$store.dispatch("logOut");
    },
    searchSubmit() {
      this.$store.dispatch("searchSubmit", this.keyword);
      this.keyword = "";
    }
  }
};
</script>

<style scoped>
.bg {
  background-size: cover;
  background-position: center;
  background-image: url("/gamer-background-2.png");
  background-attachment: fixed;
  background-repeat: no-repeat;
  min-height: 100vh;
}
a {
  text-decoration: none;
}
</style>