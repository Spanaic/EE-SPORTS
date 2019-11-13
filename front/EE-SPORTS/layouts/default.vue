<template>
  <v-app dark>
    <v-parallax
      dark
      src="http://localhost:3001/performance-3110696_1920.jpg"
      height="100%"
      width="100%"
    >
      <!-- <row align="center" justify="center"> -->
      <!-- <v-col class="text-center" cols="12"> -->
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
      </v-navigation-drawer>
      <v-app-bar :clipped-left="clipped" fixed app>
        <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
        <v-btn icon @click.stop="miniVariant = !miniVariant">
          <v-icon>mdi-{{ `chevron-${miniVariant ? 'right' : 'left'}` }}</v-icon>
        </v-btn>
        <v-btn icon @click.stop="clipped = !clipped">
          <v-icon>mdi-application</v-icon>
        </v-btn>
        <!--
      <v-btn>
        <nuxt-link to="/post_Images">トップへ行く</nuxt-link>
      </v-btn>
      <v-btn>
        <nuxt-link to="/post_images/new_post_image">新規投稿する</nuxt-link>
      </v-btn>
      <v-btn>
        <nuxt-link to="/signUp">新規登録</nuxt-link>
      </v-btn>
      <v-btn>
        <nuxt-link to="/login">ログイン</nuxt-link>
      </v-btn>
      <v-btn>
        <nuxt-link :to="`/end_users/${this.$store.state.user.id}`">マイページ</nuxt-link>
        </v-btn>-->

        <v-btn icon @click.stop="fixed = !fixed">
          <v-icon>mdi-minus</v-icon>
        </v-btn>
        <v-toolbar-title v-text="title" />
        <v-spacer />
        <v-btn icon @click.stop="rightDrawer = !rightDrawer">
          <v-icon>mdi-menu</v-icon>
        </v-btn>
      </v-app-bar>
      <v-content>
        <v-container>
          <nuxt />
        </v-container>
      </v-content>

      <v-navigation-drawer v-model="rightDrawer" :right="right" temporary fixed>
        <v-list>
          <v-list-item @click.native="right = !right">
            <v-list-item-action>
              <v-icon light>mdi-repeat</v-icon>
            </v-list-item-action>
            <v-list-item-title>Switch drawer (click me)</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-navigation-drawer>

      <v-footer :fixed="fixed" app>
        <span>&copy; 2019</span>
      </v-footer>
      <!-- </v-col> -->
      <!-- </row> -->
    </v-parallax>
  </v-app>
</template>

<script>
export default {
  data() {
    return {
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
          to: `/end_users/${this.$store.state.user.id}`
        }
      ],
      miniVariant: false,
      right: true,
      rightDrawer: false,
      title: "Vuetify.js"
    };
  }
};
</script>

<style>
</style>