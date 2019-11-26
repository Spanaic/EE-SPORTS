class RelationshipsController < ApplicationController
    protect_from_forgery :except => [:create, :destroy]

    def create
        @user = EndUser.find(params[:end_user_id])
        follow = Relationship.new(following_id: params[:id], follower_id: params[:end_user_id])
        following_user = EndUser.find(params[:id])
        if follow.save!
            render :json => follow
            @user.create_notification_follow(following_user, @user)
        else
            puts follow.errors.full_messages, status: 500
        end
    end

    def destroy
        follow = Relationship.find(params[:id])
        if follow.destroy!
            puts status: 200
        else
            puts follow.errors.full_messages, status: 500
        end
    end
end
