class EndUsersController < ApplicationController

    def index

    end

    def show

    end

    def new

    end

    def create
        user = EndUser.new(end_user_params)
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
        params.require(:end_user).permit(:email, :name, :profile_name)
    end
end