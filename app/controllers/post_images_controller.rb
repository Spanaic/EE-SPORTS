class PostImagesController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]

    def index
        # @post_images = PostImage.all
        @post_images = PostImage.page(params[:page]).per(6).reverse_order
        # kaminariでアクションごとに表示ページ数を変える場合は.per(好きな数字)をparam[:page]の後に指定する。
        @notifications = Notification.all
        @randoms = User.order("RANDOM()").limit(20)
        # .order("RAND()")でデータを取得する場合、今のデータベースの件数と、表示する件数の整合性に気をつける
        # 3件しか登録されていないのに20件ランダムに取得するような記述をするとエラーとなるagument error
        # .order("RAND()")メソッドはRAND()内の引数の数字だけランダムにレコードを取得する。()に数字が入ってなければ全件取得・・・かな？
        # .limit()メソッドは()内の引数の数字ずつ変数へと代入する
    end

    def new
        @post_image = PostImage.new
    end

    def show
        @post_image = PostImage.find(params[:id])
        @new_post_comment = PostComment.new
        @favorite = Favorite.new
        @post_comments = @post_image.post_comments.page(params[:page]).per(4).reverse_order
    end

    def create
        @post_image = PostImage.new(post_image_params)
        @post_image.user_id = current_user.id
        if @post_image.save
            redirect_to post_image_path(@post_image.id)
        else
            render :new
        end
    end

    def edit
        @post_image = PostImage.find(params[:id])
    end

    def update
        @post_image = PostImage.find(params[:id])
        @post_image.user = current_user
        if @post_image.update(post_image_params)
            redirect_to post_image_path(@post_image.id)
        else
            render :edit
        end
    end

    def destroy
        post_image = PostImage.find(params[:id])
        post_image.destroy
        redirect_to post_images_path
    end

    def hashtag
        @user = current_user
        @tag = Hashtag.find_by(hashname: params[:name])
        @post_images = @tag.post_images.build
        @post_image = @tag.post_images.page(params[:page])
    end

    def reply
        @post_image = PostImage.find(params[:id])
        @new_post_comment = PostComment.new
        @favorite = Favorite.new
        render :show
    end

    private
    def post_image_params
        params.require(:post_image).permit(:post_image, :caption)
    end
end