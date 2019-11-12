class EndUsersController < ApplicationController

    def index
        user = EndUser.find_by(email: params[:email])
        # @user= EndUser.find(id: params[:profile_name])
        users = EndUser.all
        respond_to do |format|
            format.json {
                render :json => {:user => user, :users => users}
            }
        end
        # render :json => user
        # render :json => users
        # render :json => @user

    end

    def show
        @user = EndUser.find(params[:id])
        # @user= EndUser.find_by(id: params[:profile_name])
        render :json => @user
        # @user = User.find_by(profile_name: params[:profile_name])
        # @post_images = @user.post_images.page(params[:page]).per(9).reverse_order
        # respond_to do |format|
            # format.json {render :json =>{:user => @user,:post_images => @post_images} }
        # end
    end

    def new

    end

    def create
        user = EndUser.new(end_user_params)
        # user.email = params[:end_user][:email]
        # user.name = params[:end_user][:name]
        # user.profile_name = params[:end_user][:profile_name]
        if user.save

        else
        puts user.errors.full_messages
        end
        render :json => user
    end

    def destroy

    end

    def edit

    end

    def update

    end

    def follows

    end

    def followers

    end

    def explore

    end

    private
    def end_user_params
        params.require(:end_user).permit(:email, :name, :profile_name, :id)
    end
end
