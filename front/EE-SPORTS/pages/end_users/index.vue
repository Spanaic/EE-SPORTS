<template>
  <div>
    <div v-for="(end_user, i) in end_users" :key="i">
      <nuxt-link :to="`/end_users/${end_user.id}`">{{ end_user.name }}</nuxt-link>

      <v-container fluid>
        <v-row>
          <v-col v-for="(end_user, i) in end_users" :key="i" class="d-flex child-flex" cols="4">
            <nuxt-link :to="`/end_users/${end_user.id}`">
              <v-card flat tile class="d-flex">
                <v-img
                  :src="'http://localhost:3001/end_users/' + `${end_user.profile_image_name}`"
                  :lazy-src="'http://localhost:3001/end_users/' + `${end_user.profile_image_name}`"
                  aspect-ratio="1"
                  class="grey lighten-2"
                >
                  <template v-slot:placeholder>
                    <v-row class="fill-height ma-0" align="center" justify="center">
                      <v-progress-circular indeterminate color="grey lighten-5"></v-progress-circular>
                    </v-row>
                  </template>
                </v-img>
              </v-card>
            </nuxt-link>
          </v-col>
        </v-row>
      </v-container>

      <v-card max-width="450" class="mx-auto">
        <v-list three-line>
          <template v-for="(item, index) in items">
            <v-subheader v-if="item.header" :key="item.header" v-text="item.header"></v-subheader>

            <v-divider v-else-if="item.divider" :key="index" :inset="item.inset"></v-divider>

            <v-list-item v-else :key="item.title" @click>
              <v-list-item-avatar>
                <v-img :src="item.avatar"></v-img>
              </v-list-item-avatar>

              <v-list-item-content>
                <v-list-item-title v-html="item.title">{{ end_user.id }}</v-list-item-title>
                <v-list-item-subtitle v-html="item.subtitle"></v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>
          </template>
        </v-list>
      </v-card>
    </div>
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
    console.log(res.data[1]);
  },
  computed: {
    items() {
      return [
        { header: "ユーザーリスト" },
        {
          avatar: "https://cdn.vuetifyjs.com/images/lists/1.jpg",
          title: "Brunch this weekend?",
          subtitle:
            "<span class='text--primary'>Ali Connors</span> &mdash; I'll be in your neighborhood doing errands this weekend. Do you want to hang out?"
        },
        { divider: true, inset: true },
        {
          avatar: "https://cdn.vuetifyjs.com/images/lists/2.jpg",
          title: 'Summer BBQ <span class="grey--text text--lighten-1">4</span>',
          subtitle:
            "<span class='text--primary'>to Alex, Scott, Jennifer</span> &mdash; Wish I could come, but I'm out of town this weekend."
        },
        { divider: true, inset: true },
        {
          avatar: "https://cdn.vuetifyjs.com/images/lists/3.jpg",
          title: "Oui oui",
          subtitle:
            "<span class='text--primary'>Sandra Adams</span> &mdash; Do you have Paris recommendations? Have you ever been?"
        },
        { divider: true, inset: true },
        {
          avatar: "https://cdn.vuetifyjs.com/images/lists/4.jpg",
          title: "Birthday gift",
          subtitle:
            "<span class='text--primary'>Trevor Hansen</span> &mdash; Have any ideas about what we should get Heidi for her birthday?"
        },
        { divider: true, inset: true },
        {
          avatar: "https://cdn.vuetifyjs.com/images/lists/5.jpg",
          title: "Recipe to try",
          subtitle:
            "<span class='text--primary'>Britta Holt</span> &mdash; We should eat this: Grate, Squash, Corn, and tomatillo Tacos."
        }
      ];
    }
  }
};
</script>

<style>
</style>