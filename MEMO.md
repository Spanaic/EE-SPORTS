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
