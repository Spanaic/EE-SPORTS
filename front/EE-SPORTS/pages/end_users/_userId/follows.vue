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
      follows: []
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    },
    items() {
      if (this.currentUser) {
        let itemsArray = [{ header: "フォローリスト" }];
        this.follows.forEach(following => {
          itemsArray.push({
            avatar:
              process.env.baseUrl +
              `/end_users/${following.profile_image_name}`,
            tilte: following.profile_name,
            subtitle: following.email,
            id: following.id
          });
          itemsArray.push({ divider: true, inset: true });
        });
        return itemsArray;
      }
    }
  },
  async created() {
    try {
      console.log("this.$route.params.id", this.$route.params.userId);
      const res = await axios.get(
        `/end_users/${this.$route.params.userId}/follows`,
        this.$route.params.userId
      );
      this.follows = res.data;
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