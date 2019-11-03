class RelationshipsController < ApplicationController
    def create
        @user = User.find_by(profile_name: params[:user_profile_name])
        follow = current_user.active_relationships.build(following_id: current_user.id, follower_id: @user.id)
        follow.save
        @user.create_notification_follow(current_user)
        redirect_to user_path(params[:user_profile_name])
    end

    def destroy
        @user = User.find_by(profile_name: params[:user_profile_name])
        follow = current_user.active_relationships.find_by(follower_id: @user.id)
        follow.destroy
        redirect_to user_path(params[:user_profile_name])
    end
end
