<template>
  <div>
    <div v-for="(post_image, i) in post_images" :key="i">
      <v-card class="mx-auto" max-width="400">
        <nuxt-link :to="`/post_images/${ post_image.id }`">
          <v-img
            class="white--text align-end"
            height="200px"
            :src="'http://localhost:3001/post_images/' + post_image.image_name"
          >
            <v-card-title>Top 10 Australian beaches</v-card-title>
          </v-img>
        </nuxt-link>

        <v-card-subtitle class="pb-0">Number 10</v-card-subtitle>

        <v-card-text class="text--primary">
          <div>{{post_image.caption}}</div>

          <div>Whitsunday Island, Whitsunday Islands</div>
        </v-card-text>

        <v-card-actions>
          <v-btn color="orange" text>Share</v-btn>

          <v-btn color="orange" text>Explore</v-btn>

          <v-btn icon>
            <v-icon>mdi-heart</v-icon>
          </v-btn>
          <!-- <comment-form></comment-form> -->

          <v-row justify="center">
            <v-dialog v-model="dialog" persistent max-width="600px">
              <template v-slot:activator="{ on }">
                <v-btn color="primary" dark v-on="on">コメントする</v-btn>
              </template>
              <v-card>
                <v-card-title>
                  <span class="headline">User Profile</span>
                </v-card-title>
                <v-card-text>
                  <v-container>
                    <v-row>
                      <v-col cols="12" sm="6" md="4" lg="12">
                        <v-text-field label="Outlined" outlined v-model="post_comment"></v-text-field>
                      </v-col>
                    </v-row>
                  </v-container>
                  <small>*indicates required field</small>
                </v-card-text>
                <v-card-actions>
                  <v-spacer></v-spacer>
                  <v-btn color="blue darken-1" text @click="dialog = false">Close</v-btn>
                  <v-btn color="blue darken-1" text @click="saveComment(post_image.id)">Save</v-btn>
                </v-card-actions>
              </v-card>
            </v-dialog>
          </v-row>
        </v-card-actions>

        <v-col cols="12" lg="12" sm="6" md="3">
          <!-- <v-text-field label="Outlined" outlined></v-text-field> -->
        </v-col>
      </v-card>
    </div>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import Vuex from "vuex";
import commentForm from "@/components/commentForm";

const url = "http://localhost:3001/post_images.json";

export default {
  data() {
    return {
      post_images: [],
      post_image: "",
      dialog: false,
      post_comment: ""
    };
  },
  components: {
    commentForm
  },
  mounted: async function() {
    const res = await axios.get(url);
    this.post_images = res.data.post_images;
  },
  methods: {
    async saveComment(id) {
      try {
        this.dialog = false;
        console.log(this);
        const comment = {
          comment: this.post_comment
        };
        await axios.post(`/post_images/${id}/post_comments`, comment);
      } catch (error) {
        alert("");
      }

      // .then(res => {
      //   this.post_comment = res.data.post_comment;
      // });
    }
  }
};
</script>