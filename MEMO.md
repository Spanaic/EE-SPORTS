# 学習メモ

## jsonを返す方法

【参考URL】

1.[qiitaの記事](https://qiita.com/k-penguin-sato/items/adba7a1a1ecc3582a9c9)

### シンプルかつ、返すモデルが一つの場合

```
    def index
        @users = User.page(params[:page]).per(20).reverse_order
        render :json => @users
    end
```

### 返すモデルが複数の場合

```
    def show
        @user = User.find_by(profile_name: params[:profile_name])
        @post_images = @user.post_images.page(params[:page]).per(9).reverse_order
        respond_to do |format|
            format.html
            format.json {render :json =>{:user => @user,:post_images => @post_images} }
        end
    end
```

### ルーティング設定を変更する(jsonファイルを返すように)

```
  get '/users/:profile_name' + '.json', to: "users#show" ,as: 'user_json'
```

### あまりないことだけど,viewのリンクからjsonファイルを返す場合

```
<li class="list-icon">
    <%= link_to user_json_path(current_user.profile_name) do %>
        <i class="fas fa-user-alt"></i>
    <% end %>
</li>
```

## local環境で作業をする場合
---

* rbenvでバージョンを指定を変更してあげる。
* バージョンの直下にgemなどのファイルが生成される
* バージョンごとのグローバルファイルが生成される
* 最初はバージョンごとにインストールされているgemを参照する
* プロジェクトごとにローカルでgemを管理する場合は`--path vendor/bundle`でvendor直下にgemをインストールされるように心掛ける。
* リポジトリを一つにするために、createしたnuxtディレクトリはrails直下に移動する

---


## axiosでbaseURLを設定して、各ページでそれを呼び出す運用方法

[Nuxt公式ドキュメント(axios)](https://ja.nuxtjs.org/api/configuration-env/)

1. configにbaseURLを記載する.
2. plugin直下にaxios.jsを作成する.
3. 各コンポーネントでimportする（axios.js）

---

## axiosの.thenで取ってくる方法

```
mounted() {
  axios.get("http://localhost:3001//post_images.json")
  .then(response => {this.post_images = response.data.post_images})
  .error
}
```

## axiosのasyncで取ってくる

```
  mounted: async function() {
    const response = await axios.get(url)
    // console.log(response.data.post_images);
    this.post_images = response.data.post_images;
  }
    // let that = this
    // const response = await axios.get(`/post_images`, {
    //   this.post_images = response.post_images;
  }
```

最初にdataが取れなかったのはthisのスコープが原因か、response.data.post_images;のように"data"を噛ましてなかったため。

## axiosでmthodsの@clickイベントからgetで値を取ってくる方法

```
  methods: {
  async handleSubmit () {
    const url = "http://localhost:3001//post_images.json"
    const { data } = await axios.get(url)
    this.post_images = data.post_images
  }
}
```
template内に<form></form>や<button></button>を設けて@clickイベントを設ける必要がある。

## apiサーバーとしてフロントからフォームを渡す時の設定

1. development.rb
```
  config.action_controller.forgery_protection_origin_check = false
```
2. application_controller.rb
```
    protect_from_forgery with: :null_session
```

## dotenvを用いて、環境変数を格納する方法

1. dotenvモジュールをインストール
2. firebase.jsの記述を以下に変更する。
```
import firebase from "firebase"


var firebaseConfig = {
    apiKey: process.env.API_KEY,
    authDomain: process.env.AUTH_DOMAIN,
    databaseURL: process.env.DATABASE_URL,
    projectId: process.env.PROJECT_ID,
    storageBucket: process.env.STORAGE_BUCKET,
    messagingSenderId: process.env.MESSAGING_SENDER_ID,
    appId: process.env.APP_ID
};

// Initialize Firebase
firebase.initializeApp(firebaseConfig);

export default firebase
```

3. .envファイルをディレクトリ直下に作成する.

```
API_KEY="AIzaSyAkveW6kT9EbZVBB8kyZObPvgbkX0Nj14g"
AUTH_DOMAIN="ee-sports.firebaseapp.com"
DATABASE_URL="https://ee-sports.firebaseio.com"
PROJECT_ID="ee-sports"
STORAGE_BUCKET="ee-sports.appspot.com"
MESSAGING_SENDER_ID="636627745511"
APP_ID="1:636627745511:web:86d8560ba4d67b4f890042"
```

4. nuxt.configの記述を変更する

```
require('dotenv').config();
const { API_KEY } = process.env;
const { AUTH_DOMAIN } = process.env;
const { DATABASE_URL } = process.env;
const { PROJECT_ID } = process.env;
const { STORAGE_BUCKET } = process.env;
const { MESSAGING_SENDER_ID } = process.env;
const { APP_ID } = process.env;

export default {
  mode: 'universal',
  env: {
    // baseUrl: process.env.BASE_URL || 'http://localhost:3001'
    API_KEY,
    AUTH_DOMAIN,
    DATABASE_URL,
    PROJECT_ID,
    STORAGE_BUCKET,
    MESSAGING_SENDER_ID,
    APP_ID
  },
```

const { API_KEY } = process.env;はES6の省略記法
＝＞process.env.API_KEYのこと

envは定数を記述する。

## firebaseの意味不明エラ-「Firebase App named '[DEFAULT]' already exists (app/duplicate-app)」解決法

[firebase.jsの設定方法](https://qiita.com/_takeshi_24/items/419b9d0d879351f641f3)

```
if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig)
}
```

## 三項演算子について

```
user = user? user : {};
```

三項演算子はただの条件分岐式を短縮したカタチではなく、真偽値に応じて戻り値を返す条件式となる。

## firebaseのログイン認証をvuexで管理する方法
【参考URL】[Vueでvuexで認証情報を保持する](https://qiita.com/ErgoFriend/items/bd1bb445e185bf45e272)
```
export default {
    init() {
        firebase.initializeApp(config);
        firebase.auth().setPersistence(firebase.auth.Auth.Persistence.SESSION);
    },
```
initは初期化です。
Firebase内の`initializeApp`によって,firebase.jsを読み込むことで毎回initのように初期化が実行される。そのためわざわざinitの記述をする必要はない。
`
firebase.auth().setPersistence(firebase.auth.Auth.Persistence.SESSION)
`
タブを閉じるまで。更新しても保持される

`
firebase.auth().setPersistence(firebase.auth.Auth.Persistence.NONE)
`
更新したら消える。

`
firebase.auth().setPersistence(firebase.auth.Auth.Persistence.LOCAL)
`
ユーザがログアウトするまで残る。

```
    login() {
        const provider = new firebase.auth.GoogleAuthProvider();
        firebase.auth().signInWithPopup(provider)
    },
```
`
firebase.auth().signInWithPopup(provider)
`
プロバイダを指定してログイン画面をポップアップさせる。
定数にプロバイダを指定する。
```
    logout() {
        firebase.auth().signOut()
    },
```
sessionを終了させる(ログアウトさせる)
```
    onAuth() {
        firebase.auth().onAuthStateChanged(user => {
            user = user ? user : {};
            store.commit('serUser', user);
            store.commit('onUserStateChanged', user.uid ? true : false);
        });
    }
};
```
promiseでログインが完了した後に、ユーザー情報をvuexのstorへ保存します。
`userがログアウトした後にuserのstateを{}の状態にして保存する。`

```
var user = firebase.auth().currentUser
```
`ユーザ情報を取得できる。`

## ユーザ認証の情報をstateで管理する方法

「vuex」は[index, state, mutations, actions].jsの各フォルダを持つようなカタチで管理する。（決まりは無いが今回はこのカタチで実装する）

store.jsでその他のファイルをまとめて管理する。

[index.js]
```
import Vuex from 'vuex';
import mutations from "./mutations"
import state from "./state"
import actions from "./actions";

<!-- importを忘れると機能しなくなるので,vuexの機能を持つファイルは全てindex.jsにimportすること -->

<!-- Vue.use('vuex') <=のような記述はnuxt外でvuexなどを使う際にライブラリを使用するという記述として必要となる。nuxtはデフォルトで入っているので必要がない。-->

const createStore = () => {
    return new Vuex.Store({
        state,
        mutations,
        actions,
        getters: {
            user(state) {
                return state.user;
            },
            isSignedIn(state) {
                return state.status;
            }
        }
    })

}

export default createStore;

```

vuexはvuexインスタンスを関数で返す必要があるため、定数`createStore`を関数として定義して、戻り値として[`Vuex.Store`]を返す。

export defaultするのは 関数を代入した[createStore]となる。

### state.js

```
const state = {
    user: {
    },
    status: false
}

export default state;
```
定数にstateを定義する。
オブジェクトの中にstate管理したいキーを入れる。
statusはログイン状態を真偽値で管理するための記述。
`export default state;を行わないとstateにアクセスできないので忘れないこと！（他のファイルも同じことが言える）`

### mutations.js

```
const mutations = {
    setUser(state, payload) {
        state.user = payload;
    },
    onUserStatusChanged(state, payload) {
        state.status = payload;
        <!-- state.hoge　hogeの値がstate.jsでキーとして記述した値 -->
    }
};

export default mutations;

```

stateの値を変更する関数を定義する。直接は使わずactions.jsでcommitして呼び出す。
(state, payload)は決り文句（payloadとは引数の代名詞的なやつ）

### actions.js

```

import firebase from "@/plugins/firebase"
<!-- firebase認証を使用しているので,importでfirebase.jsを読み込む -->

const actions = {
    // init() {
    //     firebase.initializeApp(config);
    //     firebase.auth().setPersistence(firebase.auth.Auth.Persistence.SESSION);
    // },

<!-- initはfirebase.jsを読み込む段階で必要が無い -->

    login({ commit }) {
        const provider = new firebase.auth.GoogleAuthProvider();
        firebase.auth().signInWithPopup(provider)
            .then(user => {
                commit("setUser", user)
            })
    },
    <!-- .thenでpromiseオブジェクトが返ってきた場合にmutations.jsで定義した関数を呼び出してstateの値を変更したいので、commit(mutations内の関数名,　今回の場合は値の入った引数)を実行する -->

    logout() {
        firebase.auth().signOut()
    },

    onAuth() {
        firebase.auth().onAuthStateChanged(user => {
            user = user ? user : {};
            store.commit('setUser', user);
            store.commit('onUserStateChanged', user.uid ? true : false);
        });
        <!-- ログイン状態を保持したいが、この記述のままだとリロードされた瞬間にstateがemptyになってしまうのでリロードされた時の状態保持の処理をpluginsかmiddlewareに記述する -->
    }
}

export default actions
```
`<!-- ログイン状態を保持したいが、この記述のままだとリロードされた瞬間にstateがemptyになってしまうのでリロードされた時の状態保持の処理をpluginsかmiddlewareに記述する -->`

pluginsとmiddlewareはbeforeCreateよりも前に最初に読み込まれるファイルのため、記述場所をそこにする必要がある。
今回はpluginsに記述し、nuxt.config.jsのpluginsに記述することで、importしなくてもライフサイクルが始まる前に認証状態の状態保持を持たせることで状態維持を可能とさせる記述を行う。


### 【例外】actions.js　payloadに入っている配列をactions側で受け取るもう一つの方法

```
    logIn({ commit }, [email, password]) {
        firebase
            .auth()
            .createUserWithEmailAndPassword(email, password)
            .then(user => {
                commit("setUser", user);
                console.log(payload);
```
このタイミングで学んだことが2つ
1. `firebaseはvalidationで「@gmail.com」などちゃんとしたメールアドレスじゃないと引っかかる`
2. `配列の番号はpayload[0]などのように鉤括弧でくくる、これは言語問わず共通ルール！`

## vuexのstateの永続化

[公式ドキュメント](https://nuxt-api-state.lec.cafe/4.Vuex%20Store%20%E3%81%AE%E6%B0%B8%E7%B6%9A%E5%8C%96/#vuex-store-%E3%81%AE%E6%B0%B8%E7%B6%9A%E5%8C%96)

[Qiita](https://qiita.com/sakapun/items/a0cf5698751ae70c8088)

[ピザまん](https://pizzamanz.net/web/vue/vuex-persistedstate/)

【良記事の匂い】[ハイパーテキストキャンディ](https://www.hypertextcandy.com/cookie-auth-and-cors-on-universal-nuxt-app-with-web-api)

---

## docker-compose.yml

```
version: '3'
services:
  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: root
    ports:
      - "3306:3306"
  api:
    build: .
    command: bash -c "rm -f tmp/pids/server.pid && rails s -p 3001 -b '0.0.0.0'"
    <!-- server.pidをrmする記述がなければ localとcontainerでポートを共有して使用してしまうため、composeを走らせる度にrmするコマンドを記述しておく -->
    <!-- bashはターミナルの言語  -->
    volumes:
      - .:/myapi
      - /myapi/temp/
    ports:
      - "3001:3001"
    depends_on:
      - db
    tty: true
  front:
  <!-- 基本的にymlファイルからみた相対パスを記述する -->
    container_name: nuxt
    build: ./front/EE-SPORTS
    command: npm run dev
    volumes:
      - ./front/EE-SPORTS:/app
      - /app/node_modules/
    ports:
      - "3000:3000"
    tty: true
```

1. server.pidをrmする記述がなければ localとcontainerでポートを共有して使用してしまうため、composeを走らせる度にrmするコマンドを記述しておく
2. bashはターミナルの言語
3. 基本的にymlファイルからみた相対パスを記述する
4. volumesの書き方は気をつける（相対パス）

## databas.yml

```
development:
  <<: *default
  database: api

# Warning: The database defined as "test" will be erased and
# re-generated from your development database when you run "rake".
# Do not set this db to the same as development or production.
test:
  <<: *default
  database: api_test

production:
  <<: *default
  database: api
```

1. database:の部分はpathで指定されているとデフォルトでsqlite3になっている。
2. pathを記述するのではなく、わかりやすいデータベース名を書く。
3. ちなみにpathで書くというルールはないのでデータベース名を自由に記述している。
4. デプロイの時にデータベース名をymlを参照して記述する。

---

## firebaseの導入方法

### firebaseのアカウント作成

1. firebaseでアカウントを作成
2. firebaseを-gインストール
3. package.jsonにmoduleを追加する

```
npm -i firebase --save
```
`--save`コマンドでpackage.jsonに追加

### dotenvで環境変数を隠す

1. dotenvをインストールする。

```
npm -i dotenv
```

2. ディレクトリ直下に[.env]ファイルを作成する。
3. firebaseのプロジェクトのコンフィグからアプリケーションを選択　＝> CDNで出てきたAPI_KEYなどなどをコピー
4. [.env]の中に記述する

```.env
任意の名前="値"

API_KEY="***"
AUTH_DOMAIN="***"
DATABASE_URL="https://***.firebaseio.com"
PROJECT_ID="***"
STORAGE_BUCKET="***.appspot.com"
MESSAGING_SENDER_ID="****"
APP_ID="1:***:web:***"
```

5. Nuxtは記述済みだが,念の為.gitignoreをチェック！なければ[.env]を追記する
6. `[nuxt.config.js]に環境変数を記述する`

```
require('dotenv').config();
const { API_KEY } = process.env;
const { AUTH_DOMAIN } = process.env;
const { DATABASE_URL } = process.env;
const { PROJECT_ID } = process.env;
const { STORAGE_BUCKET } = process.env;
const { MESSAGING_SENDER_ID } = process.env;
const { APP_ID } = process.env;

export default {
  mode: 'universal',
  env: {
    API_KEY,
    AUTH_DOMAIN,
    DATABASE_URL,
    PROJECT_ID,
    STORAGE_BUCKET,
    MESSAGING_SENDER_ID,
    APP_ID
  },
  ```

  ### firebase.js

  1. [.plugins/firebase.js]を作成
  2. [.env]で作成した記述を元に中身を編集する。

```
  import firebase from "firebase"


var firebaseConfig = {
    apiKey: process.env.API_KEY,
    authDomain: process.env.AUTH_DOMAIN,
    databaseURL: process.env.DATABASE_URL,
    projectId: process.env.PROJECT_ID,
    storageBucket: process.env.STORAGE_BUCKET,
    messagingSenderId: process.env.MESSAGING_SENDER_ID,
    appId: process.env.APP_ID
};

if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig)
}

export default firebase
```

### Vuexの準備（ログインの認証管理）

1. [state.js]の作成

`userに空の値、statusにfalseを設定しておく`

```
const state = {
    user: {
    },
    status: false
}

export default state;
```

2. [mutations.js]の作成

`commitされたときの引数を[state.js]のどこに渡すかを記述する`

```
const mutations = {
    setUser(state, payload) {
        state.user = payload;
    },
    onUserStatusChanged(state, payload) {
        state.status = payload;
    }
};

export default mutations;
```

3. [actions.js]の作成

`firebaseで認証成功 => commitでstate変更 => axios.postでapiサーバーのdbに追加`

```
import firebase from "@/plugins/firebase"

const actions = {
  logInGoogle({ commit }) {
      const provider = new firebase.auth.GoogleAuthProvider();
      firebase.auth().signInWithPopup(provider)
          .then(user => {
              commit("setUser", user)
          })
  },
  logIn({ commit }, payload) {
      firebase
          .auth()
          .createUserWithEmailAndPassword(payload[0], payload[1])
          .then(user => {
              commit("setUser", user);
                axios.post("http://localhost:3001/users", {
                    email: this.email
                    埋めたいカラム名: バインドされてきた値（this.hogehoge）
                });
              this.email = "";
              this.password = "";
              console.log("Sign-in successful.");
              this.$router.push("/");
          })
          .catch(err => {
              this.error = err.message;
              this.error_checker = true;
              console.log(this.error_checker);
          });
  },
  logOut({ commit }) {
      firebase
        .auth()
        .signOut()
        .then(user => {
            console.log(user);
            commit("setUser", user)
        })
        .catch(function (error) {
            console.log("An error happened.");
        });
    },
}

export default actions
```

4. [./plugins/authCheck.js]を作成

`plugins配下に作成することでリロードされてもライフサイクルが始まる前に読み込ませる事ができる（リロードされても認証を維持できる）`

```
import firebase from '@/plugins/firebase';
import axios from 'axios';

export default (context) => {
    const {
        store
    } = context
    firebase.auth().onAuthStateChanged(async user => {
        if (user) {
             const { data } =
             await axios.get("http://localhost:3001/users/",{
                 params:{
                     email: user.email
                 }
             })
            store.commit('setUser', user)
        }
    })
}
```

`paramsでemailを渡すことで、rails側のコントローラに「@user = User.where(email: [:params][:email])」のようなカタチでUserを引っ張ってこれる。@userをcurrent_user代わりにして、コントローラ側で処理を行い、jsonでそれを返す。`

---

## firebaseへの新規登録とmodelへのpostを同時に行う方法（User新規登録編）

### .vue側の記述

1. actions.jsに渡すpayload内の配列をdispatchの第2引数に記述する。
2. actions.js内で処理を完了させたい場合は、dispatchを呼び出すだけにする（axiosの記述も全てactions.jsに記述する）

```
 hundleSubmit() {
      this.$store.dispatch("signUp", [
        this.email,
        this.password,
        this.name,
        this.profile_name
      ]);
      //   .then(() => {
      //   const end_user = {
      //       email: this.email,
      //       name: this.name,
      //       profile_name: this.profile_name
      //   };
      //   axios.post("/end_users", {
      //       end_user
      //     //   email: end_user.email,
      //     //   name: end_user.name,
      //     //   profile_name: end_user.profile_name
      //   });
      this.email = "";
      this.password = "";
      this.name = "";
      this.profile_name = "";
      //   });
    },
```

3. `state変更とモデルへの.save処理が終了したら、data内のプロパティを空にすること！`

### actions.js側の記述

```
signUp({ commit }, payload) {
    firebase
        .auth()
        .createUserWithEmailAndPassword(
            payload[0],
            payload[1],
        )
        .then(user => {
            commit('setUser', user)
            const end_user = {
                email: user.user.email,
                name: payload[2],
                profile_name: payload[3]
            }
            axios.post("/end_users", { end_user })
            console.log(payload)
            console.log('sign up success')
        });
}
```
1. `関数内に定義した引数（payload）は関数内ならどこでも参照できる`
2. firebaseの処理が終わったら、.thenで繋げる
3. `定数[end_user]にオブジェクトを代入することで(params[:end_user][:email])のようにパラメータをapi側に送る事ができる`
4. axios.post()の第2引数にオブジェクトとして入れ込む事もできるが、それだと二重にパラメータが送られることになるので良くない。

### end_users.controller.rbの記述

```
    def create
        user = EndUser.new(end_user_params)
        if user.save
        else
        puts user.errors.full_messages
        end
        render :json => user
    end

    private
    def end_user_params
        params.require(:end_user).permit(:email, :name, :profile_name)
    end
```

1. 基本的にインスタンス変数は使う必要がない。

```
        @user.email = params[:end_user][:email]
        @user.name = params[:end_user][:name]
        @user.profile_name = params[:end_user][:profile_name]
```
2. `paramsをカラムに代入するのはストロングパラメータの記述一行で済む`

```
    private
    def end_user_params
        params.require(:end_user).permit(:email, :name, :profile_name)
    end
    <!-- 上記の3行と同じ役割を果たす -->
```
3. デバックする時はエラーメッセージをrollbackに仕込んでおく

```
        if user.save
        else
        puts user.errors.full_messages
        end
        render :json => user
```

4. モデルへの記述は気をつける（deviseから移行してきた時）

```
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable, :omniauthable
```

`deviseの記述なので怒られるよ！削除するのを忘れずに！`

5. route.rbへの記述を行いaxiosでurlを叩けるようにしておく

```
  resources :end_users, param: :profile_name do
    resource :relationships, param: :profile_name, only: [:create, :destroy]
    get :follows, on: :member
    get :followers, on: :member
    get :explore, on: :collection
  end
```
---

## Nuxt.jsのrouteを確認する方法

[Qiita参考URL](https://qiita.com/tekondo/items/80555991c019808669ef)

* `基本的には[./.nuxt/router.js]を確認すればルーティングに必要な情報はすべて手に入る。`

```
router: {
  routes: [
    {
      name: 'users-id',
      path: '/users/:id?',
      component: 'pages/users/_id.vue'
    }
  ]
}
```

* showページなど[id]によって動的に変わるページは[_id.vue]のような_(アンダースコア)を付けたファイルを生成することでパスを指定できる。


---

## databaseの永続化

[dockerとmysqlと初期化と永続化](https://qiita.com/juhn/items/274e44ee80354a39d872)

`dockerでdbを使用する場合は、dbの永続化をしなければならない`

```docker-compose.yml
version: '3'
services:
  db:
    image: mysql:5.7

    volumes:
      - ./mysql/data:/var/lib/mysql
      <!-- ローカルのマウント先は自分でフォルダを作成する -->
      <!-- var/lib/mysqlはmysqlのライブラリ先 -->
      <!-- volumesでマウントをしないとコンテナをdownする度にDBが初期化される。 -->
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: root
    ports:
      - "3306:3306"
  api:
    build: .
    command: bash -c "rm -f tmp/pids/server.pid && rails s -p 3001 -b '0.0.0.0'"
    volumes:
      - .:/myapi
      - /myapi/temp/
    ports:
      - "3001:3001"
    depends_on:
      - db

    tty: true
    stdin_open: true
    <!-- スタンダードオープンをする。ttyとstcdin_openの記述を追加しないとbinding.pryが使えない -->
```

ymlファイルを更新して、docker内でdbにアクセスする。

```
docker attach container_name
```
データベースを作成する。
```
CREATE DATABASE db名
```
これでmigrateをすることが出来るようになる。

### binding.pryの接続方法

```
docker-compose up -d
```

1. backgroundでコンテナを立ち上げる

```
docker-compose ps
```

2. container名を取得する

```
docker exec -it attach container名 (bash)
```

3. （上記のコマンドはちょっと怪しい）いつものコンソールに入れるようになる

```
mysql/data/*
```

4. .gitignoreに追記する。

## this.$router.pushとnuxt-linkの使い方(動的URL編)

1. this.$router.push
```
this.$router.push({
    name: "post_Images-id",
    params: { postImageId: res.data.id }
});
```
2. nuxt-link

```
<nuxt-link :to="{name: 'post_Images-id',params: { postImageId: res.data.id }}">
    <img v-bind:src="'http://localhost:3001/post_images/' + post_image.image_name" />
</nuxt-link>
```

`res.data.id`でリンクに飛べるかどうかは確認が必要。=>　飛べない...


## mysqlのmy.conf内の設定

[lower_case_table_names](https://moznion.hatenadiary.com/entry/2015/04/13/005641)

大文字と小文字の区別をなくす？ための設定...my.confに設定

## jsonの渡し方

```
def show
     @post_image = PostImage.find_by(id: params[:id])
    # @new_post_comment = PostComment.new
    # @favorite = Favorite.new
    # @post_comments = @post_image.post_comments.all
    # @post_comments = @post_image.post_comments.page(params[:page]).per(4).reverse_order
    respond_to do |format|
        format.json {
            render :json => {
                :post_image => @post_image,
                # :new_post_comment => @new_post_comment,
                # :favorite => @favorite,
                # :post_comments => @post_comments
            }
      # }
    end
end
```
上記のJsonの渡し方では、
```
{
    -post_image: {
        id: hogehoge
        image_name: hogehoge
    }
}
```
と階層が一個下になってしまう。これでもパラメータとしては渡ってるので、使い方次第ではキチンとした値を取得出来るはず。
```
def show
    post_image = PostImage.find(params[:id])
    render :json => post_image
end
```
渡すjsonが一つだけなら、[respond_to do]を使わない方が良い

## params

```
    axios.post(`/post_images/${id}/post_comments`, this.post_comment);
```

このまま送ってしまうと、

```
Parameters: {"こめんと"=>nil, "post_image_id"=>"4"}
api_1  | Can't verify CSRF token authenticity.
```

[this.post_comment]がparamsのキーとなってしまう。
paramsの渡し方にもよるけど、渡したい値がキーとなってしまう場合や、基本的にparamsをpostするときはオブジェクトで渡してあげたほうがいい。

```
      axios.post(`/post_images/${id}/post_comments`, {comment: this.post_comment});
```

`[parameters => { "comment": "入力した値"}]`として渡される

## jsonファイルの効率の良い渡し方

[Qiita参考記事](https://qiita.com/eggc/items/29a3c9a41d77227fb10a)

```
@post_image = PostImage.all.to_json(include: [:子モデル,:子モデル])
```

変数に一つずついれてjsonで返すのはdb的にも良くないので、アソシエーションが組まれているモデルに関しては、[to_json(include:)]を使って必要な子モデルを含めたカタチでjsonファイルをフロントに渡して上げる。

```
render :json => @post_image
```
これだけで全てが渡るイメージ。
`新規作成するときに必要だった[.new]などはjsonとして渡さなくてok`

```
@post_image = PostImage.all.to_json(include: [:post_comments, :favorites])
```
allで取得する場合

```
@post_image = PostImage.find(params[:id]).to_json(include: [:post_comments, :favorites])
```
showページ向けなどにデータを取得してくる場合
```
render :json => @post_image

```
frontへの返し方は一緒。

アソシエーションが組まれているものは、その通りに呼び出す。

## axiosを使った通信をするときなど

```
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
```

async await try =>　axiosの通信が動的に行われ、成功したらthis.$router.pushなどを実行する。

.catchでerrorを返す。

## find_by(カラム名: params[:パラメータ])の使い方に注意！

```
 @post_comment = PostImage.find_by(post_image: params[:post_image_id])
```

[find_by]を使うと指定したカラムを探しに行っちゃう。
しかし、もしそのカラムがdbやモデルに存在しないとdbさんに怒られてしまうので要注意！ `no colmun!!!`

```
@post_comment = PostImage.find(params[:post_image_id])
```

idが渡ってきてるので、普通にfind(prams[:hogehoge])で大丈夫。