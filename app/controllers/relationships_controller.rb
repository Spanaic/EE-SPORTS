class RelationshipsController < ApplicationController
    protect_from_forgery :except => [:create, :destroy]

    def create
        # @user = EndUser.find(params[:end_user_id])
        # current_user = EndUser.find(params[:id])
        follow = Relationship.new(following_id: params[:id], follower_id: params[:end_user_id])
        # follow = current_user.active_relationships.build(following_id: current_user.id, follower_id: @user.id)
        if follow.save!
            render :json => follow
        else
            puts follow.errors.full_messages, status: 500
        end
        # @user.create_notification_follow(current_user)
        # redirect_to user_path(params[:user_profile_name])
    end

    def destroy
        # @user = User.find_by(profile_name: params[:user_profile_name])
        # follow = current_user.active_relationships.find_by(follower_id: @user.id)
        follow = Relationship.find(params[:id])
        if follow.destroy!
             puts status: 200
            #  render :json => follow
        else
            puts follow.errors.full_messages, status: 500
        end
    end
    # def create
    #     @user = User.find_by(profile_name: params[:user_profile_name])
    #     follow = current_user.active_relationships.build(following_id: current_user.id, follower_id: @user.id)
    #     follow.save
    #     @user.create_notification_follow(current_user)
    #     redirect_to user_path(params[:user_profile_name])
    # end

    # def destroy
    #     @user = User.find_by(profile_name: params[:user_profile_name])
    #     follow = current_user.active_relationships.find_by(follower_id: @user.id)
    #     follow.destroy
    #     redirect_to user_path(params[:user_profile_name])
    # end
end
