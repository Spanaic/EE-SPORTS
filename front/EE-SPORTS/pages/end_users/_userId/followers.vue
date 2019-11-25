<template>
  <div>
    <v-card max-width="450" class="mx-auto">
      <v-list three-line>
        <template v-for="(item, index) in items">
          <nuxt-link :to="`/end_users/${item.id}`">
            <v-subheader v-if="item.header" :key="item.header" v-text="item.header"></v-subheader>

            <v-divider v-else-if="item.divider" :key="index" :inset="item.inset"></v-divider>

            <v-list-item v-else :key="item.title">
              <v-list-item-avatar>
                <v-img :src="item.avatar"></v-img>
              </v-list-item-avatar>

              <v-list-item-content>
                <v-list-item-title v-html="item.title"></v-list-item-title>
                <v-list-item-subtitle v-html="item.subtitle"></v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </nuxt-link>
        </template>
      </v-list>
    </v-card>
  </div>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data() {
    return {
      followers: []
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    },
    items() {
      if (this.currentUser) {
        let itemsArray = [{ header: "フォロワーリスト" }];
        this.followers.forEach(follower => {
          itemsArray.push({
            avatar:
              process.env.baseUrl + `/end_users/${follower.profile_image_name}`,
            tilte: follower.profile_name,
            subtitle: follower.email,
            id: follower.id
          });
          itemsArray.push({ divider: true, inset: true });
        });
        return itemsArray;
      }
    }
  },
  middleware: "authenticated",
  async created() {
    try {
      const res = await axios.get(
        `/end_users/${this.$route.params.userId}/followers`,
        this.$route.params.userId
      );
      this.followers = res.data;
      await this.$store.dispatch("notificationsCheck", this.$store.state.user);
    } catch (err) {
      console.log("err", err);
    }
  },
  async fetch({ store }) {
    await store.dispatch("authCheck");
  }
};
</script>

<style>
</style>