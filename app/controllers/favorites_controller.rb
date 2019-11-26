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
        @post_image.create_notification_favorite(@user)
    end

    def destroy

        favorite = Favorite.find(params[:id])
        if favorite.destroy
            render :json => favorite, status: 200
        end
    end
end
