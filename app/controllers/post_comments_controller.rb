class PostCommentsController < ApplicationController
    protect_from_forgery :except => [:create]


    def create
        @post_comment = PostImage.find(params[:post_image_id])
        end_user = EndUser.find(params[:end_user][:id])
        @new = @post_comment.post_comments.new(post_comment_params)
        @new.end_user_id = end_user.id
        if  @post_comment.save!
            @post_comment.create_notification_post_comment(end_user, @post_comment.post_comments)
            post_comments_list = @post_comment.to_json(include: [:favorites,:end_user, :hashtags, :notifications,:post_comments =>{ :include => :end_user}])
            render :json => post_comments_list
        else
            puts @post_comment.errors.full_messages
            render :json => post_comments_list , status: 500
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
