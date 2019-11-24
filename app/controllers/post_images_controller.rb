class PostImagesController < ApplicationController
    # before_action :authenticate_user!, except: [:index, :show]
    # protect_from_forgery with: :null_session
    protect_from_forgery :except => [:create]


    def index
        # @post_images = PostImage.page(params[:page]).per(6).reverse_order
        # @post_images = PostImage.page(params[:page]).reverse_order
        # Book.first.to_json(include: [:author, {publisher: {only: :name}}])

        unless params[:search].blank?
        else
            post_images = PostImage.all.order("id DESC")
            @post_images = post_images.to_json(include: [:favorites,:end_user, :hashtags, :notifications,:post_comments =>{ :include => :end_user}])
            render :json => @post_images
        end


        # @post_images = PostImage.all.to_json(include: [:post_comments, :favorites, :end_user])
        # @notifications = Notification.all
        # randoms = EndUser.order("RANDOM()").limit(20)
        # FIXME:mysqlに.order("RANDOM()").limit(20)の表現はできないかも...
        # user = EndUser.find_by(email: params[:end_user][:email])
        #  render :json => @post_images
        #  render :json => @notification
        # respond_to do |format|
        #     format.json {
        #         render :json => {
        #             :post_images => @post_images,
        #             :notifications => @notifications,
        #             # :randoms => randoms,
        #             # :current_user => user
        #         }
        #     }
        # end
    end

    def new
        @post_image = PostImage.new
    end

    # def show
    #     @post_image = PostImage.find_by(id: params[:id])
    #     # @new_post_comment = PostComment.new
    #     to_json(include:
    #     @new_post_comment = @post_image.post_comment
    #     @favorite = Favorite.new
    #     @post_comments = @post_image.post_comments.all
    #     @post_comments = @post_image.post_comments.page(params[:page]).per(4).reverse_order
    #     respond_to do |format|
    #         format.json {
    #             render :json => {
    #                 :post_image => @post_image,
    #                 # :new_post_comment => @new_post_comment,
    #                 # :favorite => @favorite,
    #                 # :post_comments => @post_comments
    #             }
    #         }
    #     end
    # end

    def show
        # @post_image = PostImage.find(params[:id])
        @post_image = PostImage.find(params[:id]).to_json(include: [:post_comments, :favorites, :end_user, :hashtags, :notifications])
        render :json => @post_image
    end

    def create

        uploaded_file =  params[:post_image][:image]
        # binding.pry
        # ext = uploaded_file.original_filename.split(".")
        file_name = params[:post_image][:image_name]
        # file_name = params[:post_image][:image_name] + "." + ext[1]
        # ['wakudei','jpg']

          output_path = Rails.root.join('public/post_images', file_name)
        #   output_path = Rails.root.join('public', uploaded_file.filename)

    	  File.open(output_path, 'w+b') do |fp|
              fp.write  uploaded_file.read
         end

        @post_image = PostImage.new(post_params)
        #  puts post_image.user_id
        # post_image.user_id =  params[:post_image][:user_id].to_i
        # binding.pry
        # user = User.first
        # # FIXME:userは後でパラメータを渡されるように設定する
        # post_image.user_id = user.id
        # post_image.image_name = uploaded_file.original_filename
        # post_iamge.caption = uploaded_file.original_filename
        # binding.pry
        if @post_image.save!
            # redirect_to post_image_path(post_image.id)
            render :json => @post_image
        else
            puts @post_image.errors.full_messages
            render :json => @post_image
        end
    end

    def edit
        @post_image = PostImage.find(params[:id]).to_json(include: [:post_comments, :favorites, :end_user, :hashtags, :notifications])
        render :json => @post_image
    end

    def update
        @post_image = PostImage.find(params[:id])
        @post_image.user = current_user
        if @post_image.update(post_image_params)
            redirect_to post_image_path(@post_image.id)
        else
            render :edit
        end
    end

    def destroy
        post_image = PostImage.find(params[:id])
        post_image.destroy
        redirect_to post_images_path
    end

    def hashtag
        # @tag = Hashtag.find_by(hashname: params[:name])
        @tag = PostImage.where("caption LIKE ?", "%#{params[:name]}%")

        tag = @tag.to_json(include: [:post_comments, :favorites, :end_user, :hashtags, :notifications])
        render :json => tag

        # @user = current_user
        # @tag = Hashtag.find_by(hashname: params[:name])
        # @post_images = @tag.post_images.build
        # @post_image = @tag.post_images.page(params[:page])
    end

    def reply
        @post_image = PostImage.find(params[:id])
        @new_post_comment = PostComment.new
        @favorite = Favorite.new
        render :show
    end

    private
    # def post_image_params
    #     params.require(:post_image).permit(:caption, :image_name, :user_id, :image)
    # end

    def post_params
        params.require(:post_image).permit(:caption, :image_name, :end_user_id, :title)
    end
end
# class PostImagesController < ApplicationController
#     # before_action :authenticate_user!, except: [:index, :show]
#     # protect_from_forgery with: :null_session
#     protect_from_forgery :except => [:create]


#     def index
#         # @post_images = PostImage.page(params[:page]).per(6).reverse_order
#         # @post_images = PostImage.page(params[:page]).reverse_order
#         post_images = PostImage.all
#         notifications = Notification.all
#         # randoms = EndUser.order("RANDOM()").limit(20)
#         # FIXME:mysqlに.order("RANDOM()").limit(20)の表現はできないかも...
#         # user = EndUser.find_by(email: params[:end_user][:email])
#         respond_to do |format|
#             format.json {
#                 render :json => {
#                     :post_images => post_images,
#                     :notifications => notifications,
#                     # :randoms => randoms,
#                     # :current_user => user
#                 }
#             }
#         end
#     end

#     def new
#         @post_image = PostImage.new
#     end

#     def show
#         @post_image = PostImage.find(params[:id])
#         @new_post_comment = PostComment.new
#         @favorite = Favorite.new
#         @post_comments = @post_image.post_comments.page(params[:page]).per(4).reverse_order
#     end

#     def create

#         uploaded_file =  params[:post_image][:image]
#         # binding.pry
#         # ext = uploaded_file.original_filename.split(".")
#         file_name = params[:post_image][:image_name]
#         # file_name = params[:post_image][:image_name] + "." + ext[1]
#         # ['wakudei','jpg']

#           output_path = Rails.root.join('public/post_images', file_name)
#         # #   TODO:pathでディレクトリを指定する
#         #   output_path = Rails.root.join('public', uploaded_file.filename)
#         # #   TODO:pathでディレクトリを指定する

#     	  File.open(output_path, 'w+b') do |fp|
#               fp.write  uploaded_file.read
#          end

#         post_image = PostImage.new(post_params)
#         #  puts post_image.user_id
#         # post_image.user_id =  params[:post_image][:user_id].to_i
#         # binding.pry
#         # user = User.first
#         # # FIXME:userは後でパラメータを渡されるように設定する
#         # post_image.user_id = user.id
#         # post_image.image_name = uploaded_file.original_filename
#         # post_iamge.caption = uploaded_file.original_filename
#         # binding.pry
#         if post_image.save!
#             # redirect_to post_image_path(post_image.id)
#             render :json => post_image
#         else
#             puts post_image.errors.full_messages
#             render :json => post_image
#         end
#     end
#     # def create

#     #     uploaded_file =  params[:post_image][:image]
#     #     # binding.pry

#     #       output_path = Rails.root.join('public', uploaded_file.original_filename)

#     # 	  File.open(output_path, 'w+b') do |fp|
#     #           fp.write  uploaded_file.read
#     #      end

#     #     @post_image = PostImage.new(post_image_params)
#     #     # binding.pry
#     #     @user = User.first
#     #     @post_image.user_id = @user.id
#     #     @post_image.caption = uploaded_file.original_filename
#     #     if @post_image.save
#     #         redirect_to post_image_path(@post_image.id)
#     #     else
#     #         puts @post_image.errors.full_messages
#     #         render :new
#     #     end
#     # end

#     def edit
#         @post_image = PostImage.find(params[:id])
#     end

#     def update
#         @post_image = PostImage.find(params[:id])
#         @post_image.user = current_user
#         if @post_image.update(post_image_params)
#             redirect_to post_image_path(@post_image.id)
#         else
#             render :edit
#         end
#     end

#     def destroy
#         post_image = PostImage.find(params[:id])
#         post_image.destroy
#         redirect_to post_images_path
#     end

#     def hashtag
#         @user = current_user
#         @tag = Hashtag.find_by(hashname: params[:name])
#         @post_images = @tag.post_images.build
#         @post_image = @tag.post_images.page(params[:page])
#     end

#     def reply
#         @post_image = PostImage.find(params[:id])
#         @new_post_comment = PostComment.new
#         @favorite = Favorite.new
#         render :show
#     end

#     private
#     # def post_image_params
#     #     params.require(:post_image).permit(:caption, :image_name, :user_id, :image)
#     # end

#     def post_params
#         params.require(:post_image).permit(:caption, :image_name, :end_user_id)
#     end
# end