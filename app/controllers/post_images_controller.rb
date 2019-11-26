class PostImagesController < ApplicationController
    protect_from_forgery :except => [:create, :destroy]

    def index

        unless params[:search].blank?
        else
            post_images = PostImage.all.order("id DESC")
            @post_images = post_images.to_json(include: [:favorites,:end_user, :hashtags, :notifications,:post_comments =>{ :include => :end_user}])
            render :json => @post_images
        end
    end

    def new
        @post_image = PostImage.new
    end

    def show
        @post_image = PostImage.find(params[:id]).to_json(include: [:favorites,:end_user, :hashtags, :notifications,:post_comments =>{ :include => :end_user}])
        render :json => @post_image
    end

    def create

        uploaded_file =  params[:post_image][:image]
        file_name = params[:post_image][:image_name]

          output_path = Rails.root.join('public/post_images', file_name)

    	  File.open(output_path, 'w+b') do |fp|
              fp.write  uploaded_file.read
         end

        @post_image = PostImage.new(post_params)
        if @post_image.save!
            render :json => @post_image
        else
            puts @post_image.errors.full_messages
            render :json => @post_image
        end
    end

    def edit
        @post_image = PostImage.find(params[:id]).to_json(include: [:post_comments, :favorites, :end_user, :hashtags, :notifications])
        render :json => @post_image
    end

    def update
        @post_image = PostImage.find(params[:id])
        @post_image.user = current_user
        if @post_image.update(post_image_params)
            # redirect_to post_image_path(@post_image.id)
        else
            render :edit
        end
    end

    def destroy
        post_image = PostImage.find(params[:id])
        post_image.destroy
        json = post_image.to_json
        render :json => json
    end

    def hashtag
        @tag = PostImage.where("caption LIKE ?", "%#{params[:name]}%")

        tag = @tag.to_json(include: [:post_comments, :favorites, :end_user, :hashtags, :notifications])
        render :json => tag
    end

    def reply
        @post_image = PostImage.find(params[:id])
        @new_post_comment = PostComment.new
        @favorite = Favorite.new
        render :show
    end

    private
    def post_params
        params.require(:post_image).permit(:caption, :image_name, :end_user_id, :title)
    end
end