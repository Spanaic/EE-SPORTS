class UsersController < ApplicationController
    def index
        @users = User.page(params[:page]).per(20).reverse_order
        render :json => @users
    end

    def show
        @user = User.find_by(profile_name: params[:profile_name])
        @post_images = @user.post_images.page(params[:page]).per(9).reverse_order
        respond_to do |format|
            format.json {render :json =>{:user => @user,:post_images => @post_images} }
        end
    end

    def edit
        @user = User.find_by(profile_name: params[:profile_name])
        render :json => @user
    end

    def update
        @user = User.find_by(profile_name: params[:profile_name])
        @user = current_user
        if @user.update(user_params)
            render :json => {status: 'SUCCESS', data: @user}
        else
            render :json => {status: 'ERROR', data: @user}
        end
    end

    def follows
        @user = User.find_by(profile_name: params[:profile_name])
        @follows = @user.followings.all
        respond_to do |format|
            format.json { render :json => {:user => @user, :follows => @follows }}
        end
    end

    def followers
        @user = User.find_by(profile_name: params[:profile_name])
        @followers = @user.followers.all
        respond_to do |format|
            format.json { render :json => { :user => @user, :followers => @followers } }
        end
    end

    def reply_user
        @user = User.find_by(profile_name: params[:profile_name])
        render :json => @user
    end

    def explore
        @users = User.page(params[:page]).per(5).reverse_order
        @randoms = PostImage.order("RANDOM()").page(params[:page]).per(9).reverse_order
        respond_to do |format|
            format.json { render :json => { :user => @users, :post_images => @randoms }}
        end
    end

    private
    def user_params
        params.require(:user).permit(:profile_image, :profile_name, :introduction)
    end
end
