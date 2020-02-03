<template>
  <div>
    <!-- NOTE:Firebaseから取得したリストを描画(トランジション付き) -->
    <transition-group name="chat" tag="div" class="list content">
      <section
        v-for="message in chat"
        :key="message.id"
        :class="[ message.name === currentUser.name ? 'message-own' : 'message']"
      >
        <div class="item-image">
          <img v-if="!message.photoURL" :src="`${baseUrl}/no_image.jpg`" width="40" height="40" />
          <img v-else :src="`${baseUrl}/end_users/${message.photoURL}`" width="40" height="40" />
        </div>
        <div class="item-detail">
          <div class="item-name">{{ message.name }}</div>
          <div :class="[ message.name === currentUser.name ? 'item-message-own' : 'item-message']">
            <nl2br class="message_text" tag="div" :text="message.message"></nl2br>
          </div>
        </div>
      </section>
    </transition-group>

    <!-- NOTE:入力フォーム -->
    <form action @submit.prevent="doSend" class="form">
      <textarea
        v-model="input"
        required="true"
        :disabled="!currentUser.id"
        @keydown.enter.shift.exact.prevent="doSend"
      ></textarea>
      <button type="submit" :disabled="!currentUser.id" class="send-button">送信</button>
    </form>
  </div>
</template>

<script>
import axios from "@/plugins/axios";
import firebase from "@/plugins/firebase";
import Nl2br from "vue-nl2br";
import moment from "moment";
import chatAuthCheck from "@/middleware/chatAuthCheck";

const db = firebase.firestore();

export default {
  middleware: "chatAuthCheck",
  components: { Nl2br },
  data() {
    return {
      baseUrl: process.env.BASE_URL,
      end_user: {},
      chat: [],
      input: null
    };
  },
  computed: {
    currentUser() {
      return this.$store.state.user;
    }
  },
  created() {
    // console.log(
    //   "this.currentUser.profile_image_name",
    //   this.currentUser.profile_image_name
    // );
    // console.log("this.$route.params.userId", this.$route.params.userId);
    // console.log(
    //   "this.$route.params.currentUserId",
    //   this.$route.params.currentUserId
    // );
    // console.log("this.$route.params.id", this.$route.params.id);
    const ref = db
      .collection("users")
      .doc(
        // `${this.$route.params.userId}` + `${this.$route.params.currentUserId}`
        `${this.$route.params.id}`
      )
      .collection("messages")
      .orderBy("date");
    ref.onSnapshot(snapshot => {
      snapshot.docChanges().forEach(change => {
        if (change.type === "added") {
          let doc = change.doc;
          this.chat.push({
            id: doc.id,
            name: doc.data().name,
            message: doc.data().msg,
            date: moment(doc.data().date).format("lll"),
            uid: doc.data().user_id,
            photoURL: doc.data().photoURL
          });
        }
      });
      this.scrollBottom();
    });
  },
  methods: {
    scrollBottom() {
      this.$nextTick(() => {
        window.scrollTo(0, document.body.clientHeight);
      });
    },
    doSend() {
      if (this.input) {
        db.collection("users")
          .doc(
            // `${this.$route.params.userId}` +
            //   `${this.$route.params.currentUserId}`
            `${this.$route.params.id}`
          )
          .collection("messages")
          .add({
            msg: this.input,
            name: this.currentUser.name,
            date: Date.now(),
            photoURL: this.currentUser.profile_image_name,
            uid: this.currentUser.id
          })
          .catch(err => {
            console.log("err", err);
          });
        this.input = null;
      }
    }
  }
};
</script>

<style scoped>
* {
  margin: 0;
  box-sizing: border-box;
  color: black;
}
.content {
  margin: 0 auto;
  padding: 0 10px;
  max-width: 600px;
}
.form {
  position: fixed;
  display: flex;
  justify-content: center;
  align-items: center;
  bottom: 0;
  height: 50px;
  width: 100%;
  background: #f5f5f5;
  margin-bottom: 3em;
}
.form textarea {
  border: 1px solid #ccc;
  border-radius: 2px;
  height: 2em;
  width: calc(100% - 6em);
  resize: none;
}
.list {
  margin-bottom: 100px;
}
.item {
  position: relative;
  display: flex;
  align-items: flex-end;
  margin-bottom: 0.8em;
}
.item-image img {
  border-radius: 20px;
  vertical-align: top;
}
.item-detail {
  margin: 0 0 0 1.4em;
}
.item-name {
  font-size: 75%;
}
/* chat相手の吹き出し */
.item-message {
  position: relative;
  display: inline-block;
  padding: 0.8em;
  background: #deefe8;
  border-radius: 4px;
  line-height: 1.2em;
}
.item-message::before {
  position: absolute;
  content: " ";
  display: block;
  left: -16px;
  bottom: 12px;
  border: 4px solid transparent;
  border-right: 12px solid #deefe8;
}
/* currentUser用の吹き出し */
.item-message-own {
  position: relative;
  display: inline-block;
  padding: 0.8em;
  background: #deefe8;
  border-radius: 4px;
  line-height: 1.2em;
}
.item-message-own::before {
  position: absolute;
  content: " ";
  display: block;
  right: -16px;
  bottom: 12px;
  border: 4px solid transparent;
  border-left: 12px solid #deefe8;
}
.send-button {
  height: 4em;
}
/* トランジション用スタイル */
.chat-enter-active {
  transition: all 1s;
}
.chat-enter {
  opacity: 0;
  transform: translateX(-1em);
}
.message {
  margin-bottom: 3px;
}
.message-own {
  text-align: right;
  margin-bottom: 3px;
}
.message-own .content {
  background-color: lightskyblue;
}
.red-text {
  color: red;
}
.message_text {
  color: #000;
}
</style>