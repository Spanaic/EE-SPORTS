class PostCommentsController < ApplicationController
    protect_from_forgery :except => [:create]


    def create
        @post_comment = PostImage.find(params[:post_image_id])
        end_user = EndUser.find(params[:end_user][:id])
        # @post_comment.post_comments.end_user_id = end_user.id
        @new = @post_comment.post_comments.new(post_comment_params)
        @new.end_user_id = end_user.id
        # user =  EndUser.find_by(email: params[:end_user][:email])
        # user.id = @post_comment.post_comments.end_user_id
        # p @post_comment.post_comments.end_user_id
        # @post_comment.post_comments.end_user_id = user.id
        # @post_image = PostImage.find(params[:post_image_id])
        # @post_comment = PostComment.new(post_comment_params)
        # @post_comment.post_image_id = @post_image.id
        # @post_comment.user_id = current_user.id
        if  @post_comment.save!
            @post_comment.create_notification_post_comment(end_user, @post_comment.post_comments)
            # redirect_to post_image_path(params[:post_image_id])
            render :json => @post_comment.post_comments
        else
            puts @post_comment.errors.full_messages
            render :json => @post_comment , status: 500
            # render template: "post_images/show"
        end
    end

    def destroy
        post_comment = PostComment.find(params[:id])
        post_comment.destroy
        redirect_to post_image_path(params[:post_image_id])
    end


    private
    def post_comment_params
        params.require(:post_comment).permit(:comment, :end_user_id)

    end
end
