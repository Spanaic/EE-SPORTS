class FavoritesController < ApplicationController
    protect_from_forgery :except => [:create, :destroy]

    def create
        @post_image = PostImage.find(params[:post_image_id])
        @user = EndUser.find(params[:end_user_id])
        favorite = @user.favorites.new(post_image_id: @post_image.id)
        if favorite.save!
            render :json => favorite
        else
            render :json => favorite, status: 500
        end
        # @post_image.create_notification_favorite(current_user)
        # @favorites = Favorite.where(post_image_id: params[:post_image_id])
        # @post_images = PostImage.all.to_json(include: [:favorites])
        # render :json => @favorites
        # render :json => @post_images
    end

    def destroy
        # @post_image = PostImage.find(params[:post_image_id])
        # @user = EndUser.find(params[:end_user_id])
        # favorite = @user.favorites.find_by(post_image_id: params[:post_image_id])
        favorite = Favorite.find(params[:id])
        if favorite.destroy
            render :json => favorite, status: 200
        end

        # @favorites = Favorite.where(post_image_id: @post_image.id)
        # @post_images = PostImage.all
    end
    # def create
    #     @post_image = PostImage.find(params[:post_image_id])
    #     favorite = current_user.favorites.new(post_image_id: @post_image.id)
    #     favorite.save
    #     @post_image.create_notification_favorite(current_user)
    #     @favorites = Favorite.where(post_image_id: params[:post_image_id])
    #     @post_images = PostImage.all
    # end

    # def destroy
    #     @post_image = PostImage.find(params[:post_image_id])
    #     favorite = current_user.favorites.find_by(post_image_id: @post_image.id)
    #     favorite.destroy
    #     @favorites = Favorite.where(post_image_id: @post_image.id)
    #     @post_images = PostImage.all
    # end
end
