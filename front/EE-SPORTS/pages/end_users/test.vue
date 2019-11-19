<template>
  <div>
    <!-- {{ end_user.name }} -->

    <!-- いいね一覧 or フォロワー一覧用 -->

    <template>
      <v-timeline>
        <v-timeline-item v-for="(end_user, i) in end_users" :key="i" large>
          <template v-slot:icon>
            <v-avatar>
              <img src="http://i.pravatar.cc/64" />
            </v-avatar>
          </template>
          <template v-slot:opposite>
            <span>{{ }}</span>
          </template>

          <v-card max-width="344" class="mx-auto">
            <v-list-item>
              <v-list-item-avatar color="grey"></v-list-item-avatar>
              <v-list-item-content>
                <v-list-item-title class="headline">Our Changing Planet</v-list-item-title>
                <v-list-item-subtitle>by Kurt Wagner</v-list-item-subtitle>
              </v-list-item-content>
            </v-list-item>

            <v-img src="https://cdn.vuetifyjs.com/images/cards/mountain.jpg" height="194"></v-img>

            <v-card-text>Visit ten places on our planet that are undergoing the biggest changes today.</v-card-text>

            <v-card-actions>
              <v-btn text color="deep-purple accent-4">Read</v-btn>
              <v-btn text color="deep-purple accent-4">Bookmark</v-btn>
              <v-spacer></v-spacer>
              <v-btn icon>
                <v-icon>mdi-heart</v-icon>
              </v-btn>
              <v-btn icon>
                <v-icon>mdi-share-variant</v-icon>
              </v-btn>
            </v-card-actions>
          </v-card>
        </v-timeline-item>
      </v-timeline>
    </template>
  </div>
</template>

<!-- ユーザー一覧用 -->
    <v-card max-width="400" class="mx-auto">
      <v-container>
        <v-row dense>
          <v-col cols="12">
            <v-card color="#385F73" dark>
              <v-card-title class="headline">Unlimited music now</v-card-title>

              <v-card-subtitle>Listen to your favorite artists and albums whenever and wherever, online and offline.</v-card-subtitle>

              <v-card-actions>
                <v-btn text>Listen Now</v-btn>
              </v-card-actions>
            </v-card>
          </v-col>

          <v-col v-for="(end_user, i) in this.end_users_list" :key="i" cols="12">
            <v-card dark>
              <!-- <v-card :color="end_user.color" dark> -->
              <div class="d-flex flex-no-wrap justify-space-between">
                <div>
                  <v-card-title class="headline" v-text="end_user.title"></v-card-title>

                  <v-card-subtitle v-text="end_user.artist"></v-card-subtitle>
                </div>

                <v-avatar class="ma-3" size="125" tile>
                  <v-img :src="end_user.src"></v-img>
                </v-avatar>
              </div>
            </v-card>
          </v-col>
        </v-row>
      </v-container>
    </v-card>

    <!-- <nuxt-link :to="`/end_users/${end_user.id}`">{{ end_user.name }}</nuxt-link> -->
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
    // いい感じのユーザリスト用(ロジックがうまく組めず...)
    // end_users_list() {
    //   var randomColor = "#";
    //   for (var i = 0; i < 6; i++) {
    //     randomColor += ((16 * Math.random()) | 0).toString(16);
    //   }
    //   return this.end_users.map(end_user => {
    //     end_user = end_user.append({
    //       color: randomColor,
    //       src:
    //         "http://localhost:3001/end_users/" +
    //         `${end_user.profile_image_name}`,
    //       title: `${end_user.profile_name}`,
    //       artist: `${end_user.name}`
    //     });
    //   });
    // }
  }
};
</script>

<style>
</style>