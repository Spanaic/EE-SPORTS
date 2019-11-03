class FavoritesController < ApplicationController

    def create
        @post_image = PostImage.find(params[:post_image_id])
        favorite = current_user.favorites.new(post_image_id: @post_image.id)
        favorite.save
        @post_image.create_notification_favorite(current_user)
        @favorites = Favorite.where(post_image_id: params[:post_image_id])
        @post_images = PostImage.all
    end

    def destroy
        @post_image = PostImage.find(params[:post_image_id])
        favorite = current_user.favorites.find_by(post_image_id: @post_image.id)
        favorite.destroy
        @favorites = Favorite.where(post_image_id: @post_image.id)
        @post_images = PostImage.all
    end
end
