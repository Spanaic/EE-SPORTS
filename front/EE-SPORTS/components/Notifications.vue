<template>
  <div v-if="currentUser.id">
    <v-menu>
      <template v-slot:activator="{ on }">
        <v-badge color="purple" left overlap>
          <template v-slot:badge>
            <span v-if="latestNotifications.length !== 0">{{latestNotifications.length}}</span>
          </template>
          <!-- <v-btn color="primary" dark v-on="on"> -->
          <v-icon large v-on="on">mdi-bell</v-icon>
          <!-- </v-btn> -->
        </v-badge>
      </template>

      <v-list>
        <template v-if="notifications.length === 0">
          <!-- {{ this.notifications }} -->
          <v-list-item-title>
            <span>新しい通知はありません。</span>
          </v-list-item-title>
        </template>
        <template v-else>
          <v-list-item
            v-for="(notification, index) in notifications"
            :key="index"
            @click="showNotificaions(notification)"
          >
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
        </template>
      </v-list>
    </v-menu>
  </div>
</template>

<script>
export default {
  data() {
    return {
      notifications: []
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    },
    latestNotifications() {
      return this.$store.state.notifications;
    }
  },
  methods: {
    async showNotificaions(notification) {
      await this.$store.dispatch("showNotifications", [
        notification.id,
        this.$store.state.user.id
      ]);
      // this.notifications = this.$store.state.notifications;
      this.notifications = this.$store.state.notifications.filter(
        notification => {
          return notification.checkted === false;
        }
      );
    }
  },
  async mounted() {
    console.log("iine!");
    await this.$store.dispatch("checkNotifications", this.$store.state.user);
    this.notifications = this.$store.state.notifications.filter(
      notification => {
        return notification.checked === false;
      }
    );
    console.log("this.notifications", this.notifications);
  }
};
</script>

<style>
</style>