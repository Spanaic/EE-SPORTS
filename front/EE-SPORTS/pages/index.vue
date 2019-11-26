<template>
  <v-container>
    <v-row>
      <v-col class="mb-10">
        <v-timeline :dense="$vuetify.breakpoint.smAndDown">
          <v-timeline-item color="purple lighten-2" fill-dot right>
            <v-card>
              <v-card-title class="purple lighten-2">
                <v-icon dark size="42" class="mr-4">mdi-magnify</v-icon>
                <h2 class="display-1 white--text font-weight-light">eスポーツって？</h2>
              </v-card-title>
              <v-container>
                <v-row>
                  <v-col
                    cols="12"
                    md="10"
                  >アメリカではすでに国が「スポーツ」として認めているほど認知されていて「複数人のプレイヤーで対戦するゲーム」のことを指します。韓国や中国でも非常に発展していて、市場規模は日本と比べて桁違いの成長を遂げています。</v-col>
                  <v-col class="hidden-sm-and-down text-right" md="2">
                    <v-icon size="64">mdi-calendar-text</v-icon>
                  </v-col>
                </v-row>
              </v-container>
            </v-card>
          </v-timeline-item>

          <v-timeline-item color="amber lighten-1" fill-dot left small>
            <v-card>
              <v-card-title class="amber lighten-1 justify-end">
                <h2 class="display-1 mr-4 white--text font-weight-light">日本におけるeスポーツ</h2>
                <v-icon dark size="42">mdi-home-outline</v-icon>
              </v-card-title>
              <v-container>
                <v-row>
                  <v-col
                    cols="12"
                    md="10"
                  >数々の名作を世界中に放ってきたゲーム大国日本ですが、eスポーツの世界では残念ながら後進国と呼ばれており、まだまだプロゲーマなどの認知度も低いのが現状です。</v-col>
                </v-row>
              </v-container>
            </v-card>
          </v-timeline-item>

          <v-timeline-item color="cyan lighten-1" fill-dot right>
            <v-card>
              <v-card-title class="cyan lighten-1">
                <v-icon class="mr-4" dark size="42">mdi-email-outline</v-icon>
                <h2 class="display-1 white--text font-weight-light">EE!Sports</h2>
              </v-card-title>
              <v-container>
                <v-row>
                  <v-col
                    cols="12"
                    md="10"
                  >そこで登場するのがEE!Sportsです！まだまだ普及は進んでいませんが、eスポーツが大好きな人同士でスコアを共有したり、お気に入りのスクリーンショットを共有してeスポーツ全体を盛り上げていきましょう！</v-col>
                </v-row>
              </v-container>
            </v-card>
          </v-timeline-item>

          <v-timeline-item color="red lighten-1" fill-dot left small>
            <v-card>
              <v-card-title class="red lighten-1 justify-end">
                <h2 class="display-1 mr-4 white--text font-weight-light">EE!Sportsの使い方</h2>
                <v-icon dark size="42">mdi-account-multiple-outline</v-icon>
              </v-card-title>
              <v-container>
                <v-row>
                  <v-col class="hidden-sm-and-down" md="2">
                    <v-icon size="64">mdi-server-network</v-icon>
                  </v-col>
                  <v-col cols="12" md="3">1. 会員登録</v-col>
                  <v-col cols="12" md="3">2. 画像投稿</v-col>
                  <v-col cols="12" md="4">3. いいねやコメント機能でみんなと交流</v-col>
                  <!-- <v-col cols="12" md="3">4. 素敵なチームメイトが見つかるかも…</v-col> -->
                </v-row>
              </v-container>
            </v-card>
          </v-timeline-item>

          <v-timeline-item color="green lighten-1" fill-dot right>
            <v-card>
              <v-card-title class="green lighten-1">
                <v-icon class="mr-4" dark size="42">mdi-phone-in-talk</v-icon>
                <h2 class="display-1 white--text font-weight-light">さぁ！始めよう！</h2>
              </v-card-title>
              <v-container>
                <v-row class="text-xs-center">
                  <v-col cols="12" md="2"></v-col>
                  <v-col cols="12" md="3" justify-content="center">
                    <nuxt-link :to="`${baseUrl}/signUp`">
                      <v-btn outlined rounded>新規登録</v-btn>
                    </nuxt-link>
                  </v-col>
                  <v-col cols="12" md="2"></v-col>
                  <v-col cols="12" md="3">
                    <nuxt-link :to="`${baseUrl}/logIn`">
                      <v-btn outlined rounded>ログイン</v-btn>
                    </nuxt-link>
                  </v-col>
                </v-row>
              </v-container>
            </v-card>
          </v-timeline-item>
        </v-timeline>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  layout: "top",
  data() {
    return {
      baseUrl: process.env.baseUrl
    };
  }
};
</script>

<style scoped>
.v-timeline:before {
  background-color: red;
}
a {
  text-decoration: none;
}
</style>