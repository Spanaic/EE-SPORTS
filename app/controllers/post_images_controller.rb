class PostImagesController < ApplicationController
    # before_action :authenticate_user!, except: [:index, :show]
    # protect_from_forgery with: :null_session
    protect_from_forgery :except => [:create]


    def index
        # @post_images = PostImage.page(params[:page]).per(6).reverse_order
        @post_images = PostImage.page(params[:page]).reverse_order
        @notifications = Notification.all
        @randoms = User.order("RANDOM()").limit(20)
        @user = current_user
        respond_to do |format|
            format.json { render :json => { :post_images => @post_images, :notifications => @notifications, :randoms => @randoms, :current_user => @user } }
        end
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

        uploaded_file =  params[:post_image][:image]
        # binding.pry

          output_path = Rails.root.join('public', uploaded_file.original_filename)

    	  File.open(output_path, 'w+b') do |fp|
              fp.write  uploaded_file.read
         end

        @post_image = PostImage.new(post_image_params)
        # binding.pry
        @user = User.first
        @post_image.user_id = @user.id
        @post_image.caption = uploaded_file.original_filename
        if @post_image.save
            redirect_to post_image_path(@post_image.id)
        else
            puts @post_image.errors.full_messages
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
        params.require(:post_image).permit(:caption)
    end
end