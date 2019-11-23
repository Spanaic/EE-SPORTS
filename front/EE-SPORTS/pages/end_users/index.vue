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
      end_users: []
    };
  },
  created: async function() {
    const res = await axios.get("/end_users");
    this.end_users = res.data[1];
  },
  async mounted() {
    await this.$store.dispatch("notificationsCheck", this.$store.state.user);
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    },
    items() {
      if (this.currentUser) {
        let itemsArray = [{ header: "ユーザーリスト" }];
        let end_users_list = this.end_users.filter(user => {
          return user.id !== this.currentUser.id;
        });
        end_users_list.forEach(user => {
          itemsArray.push({
            avatar:
              process.env.baseUrl + `/end_users/${user.profile_image_name}`,
            title: user.profile_name,
            subtitle: user.email,
            id: user.id
          });
          itemsArray.push({ divider: true, inset: true });
        });
        return itemsArray;
      }
    }
  }
};
</script>

<style scoped>
a {
  text-decoration: none;
}
</style>