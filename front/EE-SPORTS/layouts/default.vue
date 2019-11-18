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

        <!-- notification表示候補1 -->
        <!-- <v-badge class="mr-5" :bottom="bottom" :color="color" :left="left" :overlap="overlap">
          <template v-slot:badge>
            <span>
              2
            </span>
          </template>
          <v-icon large color="grey lighten-1">mdi-bell</v-icon>
        </v-badge>-->

        <!-- <v-switch v-model="closeOnContentClick" label="Close on content click"></v-switch> -->
        <!-- <v-menu top :close-on-content-click="closeOnContentClick"> -->
        <!-- notification表示候補2 -->
        <div v-if="this.currentUser">
          <v-menu top>
            <template v-slot:badge>
              <span v-if="messages > 0">{{ messages }}</span>
            </template>
            <template v-slot:activator="{ on }">
              <!-- <v-btn color="primary" dark v-on="on"> -->
              <v-icon large v-on="on" @click="checkNotifications">mdi-bell</v-icon>
              <!-- </v-btn> -->
            </template>

            <v-list>
              <template v-if="this.notifications == []">
                <!-- {{ this.notifications }} -->
                <v-list-item-title>
                  <span>新しい通知はありません。</span>
                </v-list-item-title>
                <v-else>
                  <v-list-item v-for="(notification, index) in notifications" :key="index" @click>
                    <v-list-item-title>
                      <span v-if="notification.action == follow">
                        <nuxt-link
                          :to="`/end_users/${notification.visitor_id}`"
                        >{{ notification.visitor.profile_name }}</nuxt-link>さんがあなたをフォローしました。
                      </span>
                      <span v-else-if="notification.action == favorite">
                        さんが
                        <nuxt-link :to="`post_Images/${notification.post_image._id}`">あなたの投稿</nuxt-link>にいいねしました。
                      </span>
                      <span v-else-if="notification.action = comment">
                        さんが
                        <nuxt-link :to="`post_Images/${notification.post_image._id}`">あなたの投稿</nuxt-link>にコメントしました。
                      </span>
                      <span v-else>新しい通知はありません。</span>
                    </v-list-item-title>
                  </v-list-item>
                </v-else>
              </template>
            </v-list>
          </v-menu>
        </div>

        <!-- <template v-slot:badge>
          <span v-if="messages > 0">{{ messages }}</span>
        </template>
        <v-icon large>mdi-bell</v-icon>-->

        <v-form @submit.prevent="searchSubmit" class="pt-4">
          <v-container>
            <v-text-field v-model="keyword">
              <template v-slot:label>
                <strong>"#"</strong> or
                <strong>ユーザー名</strong>
                <v-icon style="vertical-align: middle">find_in_page</v-icon>
              </template>
            </v-text-field>
          </v-container>
        </v-form>

        <!-- <v-form @submit.prevent="searchSubmit" class="pt-4">
          <v-container>
            <v-text-field v-model="keyword">
              <template v-slot:label>
                <strong>"#"</strong> or
                <strong>ユーザー名</strong>
                <v-icon style="vertical-align: middle">find_in_page</v-icon>
              </template>
            </v-text-field>
          </v-container>
        </v-form>-->
        <v-checkbox v-model="collapseOnScroll" color="white" hide-details></v-checkbox>
      </v-app-bar>

      <v-sheet id="scrolling-techniques-6" class="overflow-y-auto" max-height="1280">
        <!-- <v-parallax
          dark
          src="http://localhost:3001/performance-3110696_1920.jpg"
          height="100%"
          width="100%"
        >-->
        <div class="bg">
          <v-container style="height: 100px;"></v-container>
          <!-- <v-content> -->
          <!-- <v-container> -->
          <nuxt />
        </div>

        <!-- </v-container> -->
        <!-- </v-content> -->
        <v-footer :fixed="fixed" app>
          <v-btn icon @click="logOut" :right="right">
            <v-icon>mdi-logout</v-icon>
          </v-btn>
          <span>&copy; 2019</span>
        </v-footer>
        <!-- </v-parallax> -->
      </v-sheet>
    </v-card>
  </v-app>
</template>

<script>
import { mdiLogout } from "@mdi/js";
import { mdiBell } from "@mdi/js";
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      keyword: "",
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

      // notification/badge
      show: false,
      messages: 0,

      // notification_list
      notifications: []
    };
    // consol.log(this);
  },
  methods: {
    logOut() {
      this.$store.dispatch("logOut");
      this.$router.push("/post_Images");
    },
    // async searchSubmit () {
    //   try {
    //     await axios.get(`/post_images?`)
    //   }
    // }
    async checkNotifications() {
      let vm = this.currentUser;
      try {
        const res = await axios.get(`/notifications/${vm.id}`);
        console.log(res.data);
        // this.notifications = res.data;
        // this.notifications = res.data.map(notification => {
        //   notification.checked == false;
        // });
        this.notifications = res.data.filter(notification => {
          console.log(notification.checked);
          return (notification.checked = false);
        });
        // return notification;
        console.log(this.notifications);
      } catch (err) {
        // alert(err);
        console.log(err);
      }
    }
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    },
    items() {
      if (this.currentUser) {
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
  }
};
</script>

<style>
.bg {
  background-size: cover;
  background-position: top;
  background: url("http://localhost:3001/performance-3110696_1920.jpg");
  background-attachment: fixed;
  background-repeat: no-repeat;
  /* opacity: 0.4; */
}
</style>