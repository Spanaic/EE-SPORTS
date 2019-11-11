<template>
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
          <v-btn color="blue darken-1" text @click="saveComment">Save</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-row>
</template>

<script>
import axios from "@/plugins/axios";

export default {
  data: () => ({
    dialog: false,
    post_comment: ""
  }),
  $emit: () => ({
    post_comment: ""
  }),
  methods: {
    saveComment() {
      this.dialog = false;
      axios
        .post(
          `/post_images/${this.$route.params.id}/post_comments`,
          this.post_comment
        )
        .then(res => {
          this.$emit.post_comment = res.data.post_comment;
        });
    }
  }
};
</script>