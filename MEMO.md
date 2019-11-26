# 学習メモ

## `【jsonを返す方法】`

【参考URL】

1.[qiitaの記事](https://qiita.com/k-penguin-sato/items/adba7a1a1ecc3582a9c9)

### `シンプルかつ、返すモデルが一つの場合`

```
    def index
        @users = User.page(params[:page]).per(20).reverse_order
        render :json => @users
    end
```
---

### `返すモデルが複数の場合`

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
---

### `ルーティング設定を変更する(jsonファイルを返すように)`

```
  get '/users/:profile_name' + '.json', to: "users#show" ,as: 'user_json'
```
---

### `あまりないことだけど,viewのリンクからjsonファイルを返す場合`

```
<li class="list-icon">
    <%= link_to user_json_path(current_user.profile_name) do %>
        <i class="fas fa-user-alt"></i>
    <% end %>
</li>
```
---

## `【local環境で作業をする場合】`

* rbenvでバージョンを指定を変更してあげる。
* バージョンの直下にgemなどのファイルが生成される
* バージョンごとのグローバルファイルが生成される
* 最初はバージョンごとにインストールされているgemを参照する
* プロジェクトごとにローカルでgemを管理する場合は`--path vendor/bundle`でvendor直下にgemをインストールされるように心掛ける。
* リポジトリを一つにするために、createしたnuxtディレクトリはrails直下に移動する

---


## `【axiosでbaseURLを設定して、各ページでそれを呼び出す運用方法】`

[Nuxt公式ドキュメント(axios)](https://ja.nuxtjs.org/api/configuration-env/)

1. configにbaseURLを記載する.
2. plugin直下にaxios.jsを作成する.
3. 各コンポーネントでimportする（axios.js）

---

## `【axiosの.thenで取ってくる方法】`

```
mounted() {
  axios.get("http://localhost:3001//post_images.json")
  .then(response => {this.post_images = response.data.post_images})
  .error
}
```

---

## `【axiosのasyncで取ってくる】`

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

---

## `【axiosでmthodsの@clickイベントからgetで値を取ってくる方法】`

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

---

## `【apiサーバーとしてフロントからフォームを渡す時の設定】`

1. development.rb
```
  config.action_controller.forgery_protection_origin_check = false
```
2. application_controller.rb
```
    protect_from_forgery with: :null_session
```

---

## `【dotenvを用いて、環境変数を格納する方法】`

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

---

## `【firebaseの意味不明エラ-「Firebase App named '[DEFAULT]' already exists (app/duplicate-app)」解決法】`

[firebase.jsの設定方法](https://qiita.com/_takeshi_24/items/419b9d0d879351f641f3)

```
if (!firebase.apps.length) {
    firebase.initializeApp(firebaseConfig)
}
```

---

## `【三項演算子について】`

```
user = user? user : {};
```

三項演算子はただの条件分岐式を短縮したカタチではなく、真偽値に応じて戻り値を返す条件式となる。

---

## `【firebaseのログイン認証をvuexで管理する方法】`
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

---

## `【ユーザ認証の情報をstateで管理する方法】`

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

---

### `state.js`

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

---

### `mutations.js`

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

---

### `actions.js`

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

---

### `【例外】actions.js　payloadに入っている配列をactions側で受け取るもう一つの方法`

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

## `【vuexのstateの永続化】`

[公式ドキュメント](https://nuxt-api-state.lec.cafe/4.Vuex%20Store%20%E3%81%AE%E6%B0%B8%E7%B6%9A%E5%8C%96/#vuex-store-%E3%81%AE%E6%B0%B8%E7%B6%9A%E5%8C%96)

[Qiita](https://qiita.com/sakapun/items/a0cf5698751ae70c8088)

[ピザまん](https://pizzamanz.net/web/vue/vuex-persistedstate/)

【良記事の匂い】[ハイパーテキストキャンディ](https://www.hypertextcandy.com/cookie-auth-and-cors-on-universal-nuxt-app-with-web-api)

---

## `【docker-compose.yml】`

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

---

## `【databas.yml】`

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

## `【firebaseの導入方法】`

### `firebaseのアカウント作成`

1. firebaseでアカウントを作成
2. firebaseを-gインストール
3. package.jsonにmoduleを追加する

```
npm -i firebase --save
```
`--save`コマンドでpackage.jsonに追加

---

### `dotenvで環境変数を隠す`

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

---

  ### `firebase.js`

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

---

### `Vuexの準備（ログインの認証管理）`

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

## `【firebaseへの新規登録とmodelへのpostを同時に行う方法（User新規登録編）】`

### `.vue側の記述`

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

---

### `actions.js側の記述`

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

---

### `end_users.controller.rbの記述`

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

## `【Nuxt.jsのrouteを確認する方法】`

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

## `【databaseの永続化】`

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

---

### `binding.pryの接続方法`

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

---

## `【this.$router.pushとnuxt-linkの使い方(動的URL編)】`

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

---

## `【mysqlのmy.conf内の設定】`

[lower_case_table_names](https://moznion.hatenadiary.com/entry/2015/04/13/005641)

大文字と小文字の区別をなくす？ための設定...my.confに設定

---

## `【jsonの渡し方】`

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

---

## `【axiosのparamsの渡し方】`

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

---

## `【jsonファイルの効率の良い渡し方】`

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

---

## `【axiosを使った通信をするときなど】`

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

---

## `【find_by(カラム名: params[:パラメータ])の使い方に注意！】`

```
 @post_comment = PostImage.find_by(post_image: params[:post_image_id])
```

[find_by]を使うと指定したカラムを探しに行っちゃう。
しかし、もしそのカラムがdbやモデルに存在しないとdbさんに怒られてしまうので要注意！ `no colmun!!!`

```
@post_comment = PostImage.find(params[:post_image_id])
```

idが渡ってきてるので、普通にfind(prams[:hogehoge])で大丈夫。

---

## `【nuxt-linkのpathをリアクティブなデータから取得する方法】`
```
<nuxt-link :to="`/end_users/${end_user.id}`">{{ end_user.name }}</nuxt-link>
```

`:to=""`toをv-bindする理由は、axiosで取得したデータをdata内に代入したリアクティブなデータから[id]をバインディングするため。

## 動的にネストされたルートからaxiosで叩く方法

[動的にネストされたルート](https://qiita.com/notsunohito/items/46bc9c6ad88fed46ea14)
[$route.params取得のタイミングとライフサイクルの理解](https://qiita.com/wata01/items/314c0bdc25f116d6f50c)

```
axios.get(`/end_users/${this.$route.params.userId}/edit`)
```

`this.$route.params.ネストしているディレクトリ名(変数名扱い)`
動的にネストされた階層から$route.paramsで動的な値（id）を取得する時は、ディレクトリ名を入れないと行けないことを忘れずに！

---

## `【respond_to do を使わずに複数の値をjsonファイルで渡したい】`

```
      user = EndUser.find_by(email: params[:email])
        users = EndUser.all

        respond_to do |format|
            format.json {
                render json: {user: user, users: users}
            }
        end
```
この記述（respond_to do）だと、vue側で[axios.get("".json)]で受け取らないとundefineでエラーになる。
URL.jsonをすれば表示されるが、が通常のURLだとエラーが返される。

```
        user = EndUser.find_by(email: params[:email])
        users = EndUser.all

        end_users = []
        end_users.push(user)
        end_users.push(users)

        render :json => end_users
```

`render ;json => hoge`だと[URL.json]をしなくても[URL]をaxios.getで叩けばjsonが返ってくる。
`空の配列を適当な変数へ代入して、push(入れたいjsonの入った変数)`をすることで、

```
[{key: value}, {key: value}]
```
一つの変数に上記のカタチでjsonファイルをまとめる事ができる。

---

## `【formDataにappendした値を見る方法】`

[appendの中身を見たい！](https://qiita.com/_Keitaro_/items/6a3342735d3429175300)

```
console.log(...formData.entries());
```
ES6より追加されたスプレッド演算子を使えば、値を見ることが出来る。

---

## `【rails-API + axiosでよくあるエラー】`

### `Can't verify CSRF token authenticity.`

[Qiita参考URL](https://qiita.com/nishina555/items/4ffaf5cc57a384b66230)

formDataを渡すときにtokenを要求される.
考えられる解決方法は今の所2つ考えられる。

1. tokenを渡す.
2. tokenを要求しないようにする。

今回は②の方法で進める。

```
(apllication.controller)
protect_from_forgery with: :null_session
```
* application.controllerに上記の記述を追加する。

```
(各コントローラ)
protect_from_forgery :except => [:update]
protect_from_forgery :except => [:許可したいアクション名]
```
* authenticity tokenを要求したくないアクションを指定して、各コントローラに記述する。

---

## `【<v-img>タグの画像をバインドさせる方法(src)】`

### `OKパターン`

```
<v-img
  :src="'http://localhost:3001/end_users/' + `${this.$store.state.user.profile_image_name}`"
  height="300px"
  dark
>
```

### `NGパターン(ベタ打ち)`

```
<v-img
  :src="`http://localhost:3001/end_users/${this.$store.state.user.profile_image_name}`"
  height="300px"
  dark
>
```

### `NGパターン(require(これはvue-loaderをうまくインストール出来ればいけるかも...))`

```
<v-img
  :src="require(`http://localhost:3001/end_users/${this.$store.state.user.profile_image_name}`)"
  height="300px"
  dark
>
```
---
## `【検索フォーム(rails)】`

### `vue側：検索したいindexにサーチを投げる(axios)`

```
<div class="search-box">
        <%= form_tag(items_path,method: :get) do %>
          <%= text_field_tag :search, "", placeholder: "アーティストやタイトルで検索" %>
          <%= button_tag '<i class="fa fa-search"></i>'.html_safe, type: 'submit', :name => nil %>
        <% end %>
      </div>
```

* 検索したいモデルのindexにaxios.getでparamsを投げる。

### `コントローラの書き方`

```
def index
    unless params[:search].blank?
      artist = Item.joins(:artist).where("artist_name LIKE ?", "%#{params[:search]}%")
      track =  Item.joins(discs: :tracks).where("track_name LIKE ?", "%#{params[:search]}%")
      title = Item.where("title LIKE ?", "%#{params[:search]}%")
      merged_result = (artist | title)P
      @items = (merged_result | track)
      @items = Kaminari.paginate_array(@items).page(params[:page]).per(10)
    else
      @items = Item.page(params[:page]).per(10).reverse_order
    end
  end
```
1. 検索フォームがブランクじゃなければ検索結果用のjsonを返すように記述を変更する
2. 検索モデルに関連したモデルから引っ張ってくる場合は.joinメソッドを使う
3. "カラム名 LIKE?"で部分一致検索
4. whereメソッドの第2引数に("%#{params[:search]}%")を入れる

---

## `【リアルタイム検索（残念ながらうまくいかず）】`

[参考記事](https://blog.capilano-fw.com/?p=648)

※ 同一コンポーネント内で検索フォームを設ける場合はかなり有効な気がする...
`残念ながら上記のURLの方法では実装出来ず...`

```
<html>
<body>
<div id="app">
    <input type="text" v-model="keyword">
    <table>
        <tr v-for="user in filteredUsers">
            <td v-text="user.id"></td>
            <td v-text="user.name"></td>
            <td v-text="user.email"></td>
        </tr>
    </table>
</div>
<script src="https://cdn.jsdelivr.net/npm/vue@2.5.16/dist/vue.min.js"></script>
<script>

    new Vue({
        el: '#app',
        data: {
            keyword: '',
            users: [
                {
                    id: 1,
                    name: '鈴木太郎',
                    email: 'suzukitaro@example.com'
                },
                {
                    id: 2,
                    name: '佐藤二郎',
                    email: 'satoujiro@example.com'
                },
                {
                    id: 3,
                    name: '田中三郎',
                    email: 'tanakasaburo@example.com'
                },
                {
                    id: 4,
                    name: '山本四郎',
                    email: 'yamamotoshiro@example.com'
                },
                {
                    id: 5,
                    name: '高橋五郎',
                    email: 'takahashigoro@example.com'
                },
            ]
        },
        computed: {
            filteredUsers: function() {
                var users = [];
                for(var i in this.users) {
                    var user = this.users[i];
                    if(user.name.indexOf(this.keyword) !== -1 ||
                        user.email.indexOf(this.keyword) !== -1) {
                        users.push(user);
                    }
                }
                return users;
            }
        }
    });

</script>
</body>
</html>
```
---
## `【filterとincludes関数によるフィルタリング機能を利用したリアルタイム検索の実装】`

[参考URL](https://codepen.io/AndrewThian/pen/QdeOVa)

### `記事の記述`

```
computed: {
    filteredList() {
      return this.postList.filter(post => {
        return post.title.toLowerCase().includes(this.search.toLowerCase())
      })
    }
  }
```

---

### `自分の記述`

```
    filterdPostImages() {
      return this.post_images.filter(post_image => {
        return (
          post_image.title.includes(this.keyword) ||
          post_image.caption.includes(this.keyword) ||
          post_image.end_user.profile_name.includes(this.keyword)
        );
      });
    }
```
1. filter関数で条件を指定した新しい配列を返す。
2. includes関数でv-modelからバインドしてきた値を指定したカラムから検索させる
3. || orを使うことで、どこかにヒットしたら、という条件を追加する。
4. collback関数で返した値の入った配列をfilter関数の戻り値に入れて,computed:の値として`filteredPostImages`にreturnで返す.

### `templateの記述`

```
<div v-for="(post_image, i) in filterdPostImages" :key="i">
```

5. v-forに渡していたdataをfilter関数を通した戻り値の入ったcomputedプロパティの値と差し替える。（元はpost_images）

---

## `【自己結合のclass_nameオプションについて】`

```
    belongs_to :visitor, class_name: 'EndUser', foreign_key: :visitor_id, optional: true
    belongs_to :visited, class_name: 'EndUser', foreign_key: :visited_id, optional: true
```
`class_nameオプションはアソシエーションを組むモデル名を記述している`

---

## `【検索のクエリの投げ方】`

```
    const res = await axios.get(
      `/searches?hashname=${this.keyword}&title=${this.keyword}`
    );
```

【modelのカラム名=${keyword}`&`modelのカラム名=${keyword}】
上記で投げると複数のカラムに検索を掛けることができる。

---

## `【pushとappendの違いについて】`

* pushは配列にオブジェクトを挿入する時に使用する.

```
[] <= {key: value}
[] <= {key: value, key: value, key: value}
複数のハッシュを挿入することも可能
```
```
[{},{}] <= 複数のオブジェクトを配列にpushしたい場合は、処理を分ける
[{},{}].push({key: value, key: value}) => [{}, {}, {}]
[{},{},{}].push({key: value}) => [{},{},{},{}]
という感じになる
```
例)

```
computed: {
    items() {
      let itemsArray = [{ header: "ユーザーリスト" }];
      this.end_users.forEach(user => {
        itemsArray.push({
          avatar: `http://localhost:3001/end_users/${user.profile_image_name}`,
          title: user.profile_name,
          subtitle: user.email
        });
        itemsArray.push({ divider: true, inset: true });
      });
      return itemsArray;

      // return [
      //   { header: "ユーザーリスト" },
      //   {
      //     avatar: "https://cdn.vuetifyjs.com/images/lists/1.jpg",
      //     title: "Brunch this weekend?",
      //     subtitle:
      //       "<span class='text--primary'>Ali Connors</span> &mdash; I'll be in your neighborhood doing errands this weekend. Do you want to hang out?"
      //   },
      //   { divider: true, inset: true },
```

* appendはオブジェクトにオブジェクトを足していくときに使用する。
* * これを`連想配列`と呼ぶ

```
{key: value}.append({key2: value2}) => {key: value, key2: value2}
```
例）

```
 handleSubmit() {
      const formData = new FormData();
      var timestamp = new Date().getTime();
      var filename = "file" + timestamp + ".jpg";
      console.log(this.uploadFile);
      formData.append("post_image[image]", this.file);
      formData.append("post_image[caption]", this.caption);
      formData.append("post_image[title]", this.title);
      formData.append("post_image[image_name]", filename);
      formData.append("post_image[end_user_id]", this.$store.state.user.id);
      this.loading = true;
      var vm = this;
      axios.post("http://localhost:3001/post_images", formData).then(res => {
        // console.log(res);
        this.$router.push(`/post_Images/${res.data.id}`);
```

---

## `【filter関数で「◯◯以外」の値を取得する】`

1. currentUser以外の値を取得したい場合

```
    items() {
      if (this.$store.state.user && this.$store.state.user != undefined);
      console.log("currentUser", this.currentUser);
      let itemsArray = [{ header: "ユーザーリスト" }];
      let end_users_list = this.end_users.filter(user => {
        return user.id !== this.currentUser.id;
      });
      console.log("end_users_list", end_users_list);
      end_users_list.forEach(user => {
        itemsArray.push({
          avatar: `http://localhost:3001/end_users/${user.profile_image_name}`,
          title: user.profile_name,
          subtitle: user.email,
          id: user.id
        });
        itemsArray.push({ divider: true, inset: true });
      });
      console.log(itemsArray);
      return itemsArray;
```

2. filter関数を実行している部分

```
let end_users_list = this.end_users.filter(user => {
        return user.id !== this.currentUser.id;
      });
```

3. 各要素のidを比較演算子でcurrentUser.idと比較する
4. !==なのでcurrentUser.idとmatchしなかったものを戻り値としてreturnする。

```
      end_users_list.forEach(user => {
        itemsArray.push({
          avatar: `http://localhost:3001/end_users/${user.profile_image_name}`,
          title: user.profile_name,
          subtitle: user.email,
          id: user.id
        });
        itemsArray.push({ divider: true, inset: true });
      });
      console.log(itemsArray);
      return itemsArray;
```

5. forEach関数でで各要素にpushでobjectを挿入している
6. 別のオブジェクトを配列として入れる({},{})場合は、もう一度pushする

---

## `【ハッシュタグにリンクを付ける方法】`

0. 前準備(全て同じ関数内の処理)

```
const res = await axios.get(url);
    let current_user_id = this.user.id;
    this.post_images = res.data.map(post_image => {
      post_image.isFav = post_image.favorites.some(fav =>
        console.log(
          "fav.end_user_id === current_user_id",
          fav.end_user_id === current_user_id,
          "fav",
          fav,
          "current_user_id",
          current_user_id
        )
      );
```

1. mapしてきたpost_imageをしようして,captionのhashを置換する

```
      post_image.caption = post_image.caption.replace(
        /[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/,
        this.post_image.hashtag.hashname
      );
```

2. 受け取ったhashnameを<a>タグのリンクに変換

```
      post_image.hashtag_list = post_image.hashtags.map(hashtag => {
        hashtag.hashname = hashtag.hashname
          .split(["#", "＃"])
          .join("")
          .link(`/post/hashtag/${hashtag.hashname}`);
        return hashtag;
      });
```
---
## `【watchを使ったstateの管理】`

* `値が変更されたら処理を実行させる`
* `stateの値がsetされてから処理を実行させるために,if文で「値があったら」の条件を付ける`
* `watchは値が変更される度に処理が繰り返さえる。`
* `if文内の処理が終われば、unwatch();でwatch処理をストップさせる`

```
created() {
    const unwatch = this.$store.watch(
      state => state.user,
      async (newUser, oldUser) => {
        console.log("state1", newUser);

        if (newUser.name) {
          console.log("state2", newUser);
          try {
            const res = await axios.get(`/notifications/${newUser.id}`);
            // console.log("resssssssss", res);
            // return this.notificationsAsync(res);
            this.notifications = res.data.filter(notification => {
              // console.log("notification.checked", notification.checked);
              return notification.checked === false;
            });
          } catch (err) {
            // alert(err);
            console.log("Notifications err", err);
            return null;
          }
          unwatch();
        }
      }
    );
  },
```
---
## `【秦さん流、asyncで処理を遅らせて値をセットする方法】`

```
  computed: {
    currentUser() {
       if (this.$store.state.user && this.$store.state.user.id != undefined) {
         this.notifications = this.notificationFilter(this.$store.state.user);
       }
      },

  methods: {
    async notificationFilter(currentUser) {
      let vm = currentUser;
      try {
        const res = await axios.get(`/notifications/${vm.id}`);
        return this.notificationsAsync(res);
      } catch (err) {
        return null;
      }
    },
    notificationsAsync(res) {
      let notifications = null;
      try {
        notifications = res;
        if (notifications != undefined) {
          notifications = notifications.data.filter(notification => {
            return notification.checked === false;
          });
          return notification;
        }
      } catch (err) {
         alert(err);
      }
      return notifications;
    }
  }
```
---

## `【型変換のdebug方法】`

```
    console.log("type of this.notifications", typeof this.notifications);
    console.log("toString this.notifications",toString.call(this.notifications));
```

### `storing => numberへの変換（javascript）`

```
parseInt(string型となっている変数や値)
```
---

## `【whereのチェーンメソッド　"or"　の使い方】`

```
post_images = PostImage.where("title LIKE ?", "%#{params[:search]}%").or(PostImage.where("caption LIKE ?", "%#{params[:search]}%"))
```

* .orを使うとメソッドチェーンとなり、一つの変数(配列)に.whereで検索してきた値（オブジェクト）を挿入してまとめることが出来る。
* .jsonで返す時に値を取りやすい。このあたりの工夫はapi側で行うこと。

---

## `【javascript　vue.js state管理 nullと{}や[]の値、条件分岐の返り値について】`

1. コンポーネントのdataと同じように初期値を入れておくことが出来る

```
<state.js>

user: {}

if(user) => true

{{ user.id }} =>　undefined
```

2. 空の初期値を入れておくと、ifで条件分岐を行った際に、その値を指定することが出来る
3. その場合は,stateの値をzeroにするcommitを行う際に,null & undefined & emptyではなく、初期値に戻すための値をpayloadに入れる(commit, payload)
4. id: 0という組み合わせはfalseを返す（下の表を参照）

```
<state.js>

const state = {
    user: {id: 0},

if(user) => true
if(user.id) => false

```
4. 最初からnullを入れておく方法もある
5. nullを入れておく場合、nullを考慮に入れた条件分岐を掛ける必要がある.
```
<state.js>

user: null

if(user) => false

```
6. vuexの`this.$store.state`を使用した値でundefinedが出る場合は、`vuexの初期値に何をsetしているか`しっかり確認する
7. 静的型付け言語では,初期値を空にして置いておくと怒られる。型は今から気をつけておくと、怒りっぽい言語に行っても頑張れそう...

---
## `【pushさせるタイミングについて】`

1. Vuexのaction.jsを経由する場合、axiosなどの非同期通信が発生する。
2. dispatchの後にpushを記述すると、axiosなどの非同期通信を待たずにpushしてしまうため、push先でresを必要としている場合エラーがでる。

```
<悪い例>
    logOut() {
      this.$store.dispatch("logOut");
      this.$router.push("/post_Images");
```

3. action.jsで axios -> commit -> push のような流れでresを受け取るのをasyncで待った後にpushすることで値を持ったまま遷移できてエラーも起きない...はず。

```
<良い例>
logOut({ commit }) {
  firebase
      .auth()
      .signOut()
      .then(user => {
          console.log(user);
          commit("setUser", { id: 0 });
          console.log('logout success!')
          this.$router.push("/post_Images")
      })
      .catch(function (error) {
          console.log("An error happened.");
      });
    },
```
---

## `【asyncData & fetchの使い方】`

### `fetchとは？`

1. コンポーネントがレンダリングされる前に呼び出される。
2. async await dispatchを駆使することで、promiseを受け取ってからコンポーネントをレンダリングさせることが可能
3. fetchはVuexのstoreにstateをセットするために使う。その値をthisなどで参照することは出来ない。あくまでstore経由で呼び出して使う

```
<コンポーネント側>

  async fetch({ store }) {
    await store.dispatch("authCheck");
  }
```

```
<actions.js側>

authCheck({ commit }) {
        firebase.auth().onAuthStateChanged(async user => {
            if (user) {
                // console.log(user)
                const { data } =
                    await axios.get(`/end_users?email=${user.email}`)
                commit('setUser', data[0])
                console.log(data);
            }
        })
    }
```

4. fetch => stateに値をset => computedに値を格納 => computed経由でstoreの値を参照して、コンポーネント内で処理をさせる

### asyncDataとは？

1. コンポーネントがレンダリングされる前にdataに値をセットするために使用する
2. セットした値はstoreに格納することなく、参照することが出来る。
3. ※まだ実際に使ったことがないので,使ったらメモします！

---

## `【配列の一番最後を取り出す方法】`

[参考Qiita](https://qiita.com/DecoratedKnight/items/aa2522d6f6291cac8961)

```
  let byeFav = ps.slice(-1)[0];
```
1. .slice(-1)[0]を指定すると取得した配列の一番最後のみ変数へと入れる事ができる。

```
let byeFav = ps[ps.length - 1];
```

2. 配列の最後の要素のみを取り出すなら、関数を使うより配列の一番最後を指定したほうが処理が走らず、早い。（こっちがおすすめ）

## `【空要素(undefined, null等)を取り除く方法】`

[参考Qiita](https://qiita.com/akameco/items/1636e0448e81e17e3646)
[シンプルな記事](http://www.irohabook.com/js-array-filter-undefined)

```
    let byeFav = ps.filter(Boolean);
```

`配列の最後を取り除くより確実なのでこちらを採用します`index/post_images

---

## `【ネストされた this.$route.params のidについて】`

```
console.log("this.$route.params.id", this.$route.params.userId);
```
`ネストされた場合だとparamsの取得pathが変更されているので注意が必要`

---

## `【関数内の変数について】`

関数内の変数を使う際は`this`を付けない！逆に値が取れない！

---

## `【日本語のデコード処理】`

[参考記事](https://javascript.programmer-reference.com/js-url-encode-decode/)

```
<template>
  <div>
    <v-text>{{ decodeHashtag($route.hash) }}</v-text>
  </div>
</template>

<script>

methods: {
    decodeHashtag(hashtag) {
    let japaneseTag = decodeURIComponent(hashtag);
    return japaneseTag;
  }
}

</script>
```

1. ハッシュタグのようにエンコードされた日本語が含まれている場合はdecode関数を用いて日本語変換することが可能
2. メソッド化して、変換したいtagを引数として渡してあげるだけ。返り値を返すのを忘れずに！
3. template内で、methodで処理した返り値を受け取って{{マスタッシュ内}}で【値】として表示してあげる。

---

## `【TypeError: _vm.destroyFavorite is not a function / Vue warn]: Property or method “name” is not defined on the instance but referenced during render】`

[is not a function](https://teratail.com/questions/193004)
[is not defined on the instance](https://forum.vuejs.org/t/vue-warn-property-or-method-name-is-not-defined-on-the-instance-but-referenced-during-render/34887)

* 解決方法は、methodsの外側に定義されていた関数を内側に戻すだけ。インデントをあわせる時にミスをした模様。
```
methods: {
  function(){

  }
}
function(){

}
```

---

## `【複数画像のアップロード】`

```
<template>
   <form action @submit.prevent="handleSubmit" enctype="multipart/form-data">
      <!-- <input type="text" v-model="end_user.email" /> -->
      <input type="text" v-model="end_user.name" />
      <input type="text" v-model="end_user.profile_name" />
      <img :src="`http://localhost:3001/end_users/${this.end_user.profile_image_name}`" alt />
      <!-- <input type="submit" /> -->

      <label v-show="!uploadedImage" class="input-item__label">画像を選択</label>
      <input type="file" @change="onFileChange" />

      <div class="preview-item">
        <img v-show="uploadedImage" class="preview-item-file" :src="uploadedImage" alt />
        <div v-show="uploadedImage" class="preview-item-btn" @click="remove">
          <p class="preview-item-name">{{ img_name }}</p>
        </div>
      </div>
      <input type="submit" id="apply-upload" v-show="uploadedImage" />
    </form>
</template>

<script>

data() {
    return {
      end_user: {},
      uploadedImage: "",
      img_name: "",
      files: [],
      itemLength: 0,
      loading: false
      // name: "",
      // profile_name: ""
    };
  },
methods: {
    onFileChange(e) {
      console.log(e);
      const files = e.target.files;
      this.createImage(files[0]);
      console.log(files[0]);
      this.files = files;
      this.img_name = files[0].name;
    },
    // アップロードした画像を表示
    createImage(file) {
      const reader = new FileReader();
      console.log(reader);
      reader.onload = e => {
        console.log(e);
        this.uploadedImage = e.target.result;
      };
      reader.readAsDataURL(file);
    },
    remove() {
      this.uploadedImage = false;
    },
    handleSubmit() {
      const formData = new FormData();
      var timestamp = new Date().getTime();
      var filename = "file" + timestamp + ".jpg";
      //   console.log(this.uploadFile);
      formData.append("end_user[image]", this.files[0]);
      formData.append("end_user[name]", this.end_user.name);
      formData.append("end_user[profile_image_name]", filename);
      formData.append("end_user[profile_name]", this.end_user.profile_name);
      //   formData.append("end_user[email", this.end_user.email);
      //   TODO:emailの変更を行う場合は、firebaseも一緒に変更しないとならない
      this.loading = true;
      var vm = this;
      console.log("----------------");
      console.log(...formData.entries());
      axios
        .put(
          `http://localhost:3001/end_users/${this.$route.params.userId}`,
          formData
        )
        .then(res => {
          console.log(res);
          this.$router.push({
            name: "end_users-id",
            params: { id: res.data.id }
          });
        });
    }
  }

</script>
```

## `【pluginsにおけるbeforeEachについて（大形さん）】`

1. plugins内でbeforeEachをしても、処理を待ってくれない。
2. firebase.auth().onAuthStateChangedはなぜかpromiseを返してくれないため,古い技術であるpromise関数を用いている
3. promise関数はasync前の技術でpromise内の処理が完了してresloveを返すまで待ってくれる。
4. SSRの場合は、公式が推奨しているのはサーバ側へ処理を投げて、処理されたものをクライアント側に投げつける流れ
5. 各ページで認証をベタ書きする場合も多い
6. 今回はSPAなのでpluginsにpromiseを返す記述をした。

```
import firebase from '@/plugins/firebase';
import axios from '@/plugins/axios';
// import { functions } from 'firebase';

export default async (context, inject) => {
    const {
        store
    } = context

    await new Promise(async (resolve, reject) => {
        firebase.auth().onAuthStateChanged(async user => {
            // console.log("test")
            if (user) {
                // console.log(user)
                // const { data } =
                const res = await axios.get(`/end_users?email=${user.email}`)
                store.commit('setUser', res.data[0])
                console.log("setUser", res.data[0]);

                const notification_res = await axios.get(`/notifications/${res.data[0].id}`)
                store.commit('setNotifications', notification_res)
                console.log("serNotifications", notification_res)
            }

            resolve();
        });
    });
}
```
---

## `【middlewareとpluginsの違い】`

1. middlewareはrouterを通る度に処理を行う
2. pluginsはリロードなど、最初に処理を行った後はコンポーネント間を移動しても処理されない。

---

## `【ストロングパラメータの指定とparamsの参照の仕方】`

```
 Parameters: {"comment"=>"こここ", "end_user"=>{"id"=>3, "email"=>"test@gmail.com", "name"=>"test", "profile_name"=>"test_user", "profile_image_name"=>"file1574415602533.jpg", "created_at"=>"2019-11-19T04:31:20.000Z", "updated_at"=>"2019-11-22T09:40:02.000Z"}, "post_image_id"=>"5", "post_comment"=>{"comment"=>"こここ"}}
```

` "post_comment"=>{"comment"=>"こここ"}}`

paramsの最後のpost_commentの部分を見ている。
この部分にparamsとして渡った値をストロングパラメータでnewレコードに挿入することが出来る

```
def post_comment_params
        params.require(:post_comment).permit(:comment, :end_user_id)
    end
```

上記の場合だと、:end_user_idが欲しくてもparamsに渡っていないため、ストロングパラメータで値を渡すことが出来ない。

---

## `【関連テーブル（孫テーブル）のjsonを取得する記述方法】`

```
@post_images = post_images.to_json(include: [:favorites,:end_user, :hashtags, :notifications,:post_comments =>{ :include => :end_user}])
```

1. 子の関連テーブルに孫の関連テーブルをinclude:させることでアソシエーションされたデータをクライアント側に渡すことができる。

---
## `【asyncData fetch】`

### `asyncData`

1. thisが使えない。storeも参照できない
2. 使い方としては、axiosで叩いたデータで初期を上書きするときに用いる。
3. ライフサイクルとの最大の違いは、レンダリングを始めずに、処理をきちんと待ってくれる。
4. 取得した生dataは,dataに上書きすることが出来る。
3. dataの値を上書きする。 data => asyncData =>　lifeSycle

### `fetch`

1. axiosなどで叩いたデータをレンダリングが始まる前にstoreに格納するときに用いる。
2. thisが参照出来ない。storeも参照出来ない。
3. 取得した値を直接dataに渡すことも出来ない。
4. asyncDataと同じく、処理が終わるまでライフサイクルは始まらない。

### `後でさせたい処理`

watch内にあとでさせたい処理を記述して、先に描画に必要な部分を処理させることが出来る

```
async created() {
    this.post_image = this.raw_post_image;
    this.post_image.caption.replace(
      /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
      ""
    );
    this.post_image.hashtags.map(hashtag => {
      hashtag.hashname.replace(/[#＃]/gm, "");
    });

    const unwatch = this.$store.watch(
      state => state.user,
      async (newUser, oldUser) => {
        console.log("state2", newUser);
        if (newUser.id) {
          try {
            const res = await axios.get(url + `/${this.$route.params.id}`);
            let current_user_id = this.user.id;
            console.log("current_user_id", current_user_id);
            console.log("res.data", res.data);
            console.log("post_image.end_user.id", res.data.end_user.id);

            this.post_image = res.data;

            console.log(
              "this.post_image.end_user.id",
              this.post_image.end_user.id
            );

            this.post_image.favorites.forEach(fav => {
              if (fav.end_user_id === current_user_id) {
                return (res.data.isFav = true);
              } else {
                return (res.data.isFav = false);
              }
            });
            this.post_image.caption.replace(
              /[#＃][Ａ-Ｚａ-ｚA-Za-z一-鿆0-9０-９ぁ-ヶｦ-ﾟー._-]+/gm,
              ""
            );
            console.log("this.post_image.caption", this.post_image.caption);

            this.post_image.hashtags.map(hashtag => {
              hashtag.hashname.replace(/[#＃]/gm, "");
            });
            console.log("this.post_image.hashtags", this.post_image.hashtags);
          } catch (err) {
            console.log("err", err);
          }
        }
      }
    );
  },
  async asyncData({ params }) {
    try {
      const res = await axios.get(url + `/${params.id}`);
      return {
        raw_post_image: res.data
      };
    } catch (err) {
      console.log("err", err);
    }
  },
```

1. `ライフサイクルはレンダリングを待ってくれない`
2. `asyncで処理をawaitさせることは出来るけど、非同期なのでレンダリングは進んでしまう`
3. `ライフサイクルをコントロールするために、asyncData, fetch, middleware, plugins, storeを駆使する`
4. `pagesのindex.vueの前に、もう一つにエントリーポイントを作成することで、v-ifを噛ませて条件分岐を行う設計`

## `【Vuex 配列が初期値の場合　データを初期化する方法と初期化されたかどうかを判定する方法】`

### `データの初期化`

1. 空の配列が初期値に入っている場合,　commitで空の初期値を入れ直して上げることでデータを初期化させることが出来る。

```
    cancelSearch({ commit }) {
        commit('setSearchResult', [])
        this.$router.push("/post_Images/")
    },
```

### `stateがセットされているかどうかを判定する方法`

2. stateの配列の中の数で判定する。空の場合は"0になるので" `length !== 0`などで判定できる。

```
<v-btn v-if="$store.state.search.length !== 0 " @click="cancelSearch">画像一覧に戻る</v-btn>
```

---

## `【バックグラウンドイメージの要素を画面の高さに固定する】`

`min-height: 100vh;`

---

## `【デプロイ後の環境変数の設定】`

```
export default {
  env: {
    API_URL: process.env.IIKANKYO ? "http://123.456.789/" : "http://localhost:3000/"
  },
```

1. nuxt.configに下記の記述を書き加える
2. 本番環境とデプロイ環境で見に行くURLを分ける

```
  mounted () {
      console.log(process.env.API_URL);
  }
```

3. mountedなどで叩きに行くbaseUrlをenvから引っ張る

```
$ yarn dev
$ IIKANKYO=unko yarn generate
```

4. 開発環境と本番環境用で変化する

---

## `【ナビゲーションガードを行う方法】`

1. おのキャンはmiddlewareにpathを一つずつ記述して、遷移前にstate.userを確認させていた
2. 公式では,`state.userの値がセットされていなければ"/"へと飛ばす処理のみ`を記述している。
3. 未ログインユーザなど絶対に弾きたいPageコンポーネントでのみ、middlewareを記述して読み込ませる

```
export default function ({ store, redirect }) {
    // ユーザーが認証されていないとき

    if (store.state.user.id === 0) {
        return redirect('/login')
    }
}
```

4. middlewareに`authenticated.js`を作成して上記の記述を行う。

```
middleware: "authenticated",
```

5. Pageコンポーネント内で、middlewareプロパティに読み込みたいmiddlewareのファイル名を記述する。

---

## `【確実にログイン認証を永続化させる方法】`

1. ログイン認証の一番の敵はリロード時。
2. default.vue内の最初から2番目のdivタグにv-ifをかませる
3. currentUserの値を取得できるまではレンダリングをさせない
4. それに加えて、値を取得している間はloadingコンポーネントを設置
5. userの値がVuexにセットされたら、loadingをオフにして、mountさせる。
6. ソースは無いので、次回は試してみよう。

---

## `【v-timelineの縦線の色を変える方法】`

```
<style scoped>
.v-timeline:before { background-color: red; }
</style>
```

1. v-timelineのあるコンポーネントで上記の記述を追加して、色指定するだけ。

---

## `【ページ毎にbackground-imageやcolorを変更する方法】`

1. layout/〇〇.vueという新たなファイルを作成
2. 新たに作成したstyleを適用したいページで読み込む

```
export default {
  layout: "〇〇",
  data (){
    ...
  }
}
```
---

## `【他のユーザの侵入を防ぐmiddlewareの使用方法】`

1. middlewareの中に新しいファイルを作成する

```
<userAuth.js>
export default function ({ store, redirect, route }) {
    // 現在のユーザーとリクエストされたユーザーが食い違う場合
    if (route.params.userId !== store.state.user.id) {
        return redirect(`/end_users/${store.state.user.id}`)
    }
}
```

2. バリデーションをかけたいページにmiddlewareを差し込む(export default内)

```
middleware: ["authenticated", "userAuth"],
```

3. middlewareを複数かませる場合は、配列として記述する。

---


## `【EC2にdockerをインストールする方法】`

[Qiita参考記事](https://qiita.com/reoring/items/0d1f556064d363f0ccb8)

