class EndUsersController < ApplicationController
    protect_from_forgery :except => [:update]


    def index
        user = EndUser.find_by(email: params[:email])
        # @user= EndUser.find(id: params[:profile_name])
        users = EndUser.all

        end_users = []
        end_users.push(user)
        end_users.push(users)

        render :json => end_users
        # respond_to do |format|
        #     format.json {
        #         render json: {user: user, users: users}
        #     }
        # end
        # render :json => user
        # render :json => users
        # render :json => @user

    end

    def show
        @user = EndUser.find(params[:id]).to_json(include: [:favorites, :post_images, :post_comments, :active_relationships, :passive_relationships, :followings, :followers])
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
        if user.save!

        else
        puts user.errors.full_messages
        end
        render :json => user
    end

    def destroy

    end

    def edit
        @user = EndUser.find(params[:id])
        render :json => @user
    end

    def update
        uploaded_file =  params[:end_user][:image]
        file_name = params[:end_user][:profile_image_name]
        output_path = Rails.root.join('public/end_users', file_name)

        File.open(output_path, 'w+b') do |fp|
            fp.write  uploaded_file.read
        end

        end_user = EndUser.find(params[:id])

        if end_user.update!(end_user_params)
            render :json => end_user
        else
            puts end_user.errors.full_messages
            render :json => end_user
        end
    end

    def follows

    end

    def followers

    end

    def explore

    end

    private
    def end_user_params
        params.require(:end_user).permit(:email, :name, :profile_name, :profile_image_name)

        # params.require(:post_image).permit(:caption, :image_name, :end_user_id)
    end
end
