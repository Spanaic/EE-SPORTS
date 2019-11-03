module PostImagesHelper
    def render_with_hashtags(caption)
        caption.gsub(/[#＃][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/post/hashtag/#{word.delete("#")}"}.html_safe
    end

    def render_with_post_comment(comment)
        comment.gsub(/[@][\w\p{Han}ぁ-ヶｦ-ﾟー]+/){|word| link_to word, "/users/#{word.delete("@")}"}.html_safe
    end
end
