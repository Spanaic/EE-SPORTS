class SearchesController < ApplicationController
  def index
    # hashtags = Hashtag.where("hashname LIKE ?", "%#{params[:search]}%")
    post_image_titles = PostImage.where("title LIKE ?", "%#{params[:search]}%")
    post_image_captions = PostImage.where("caption LIKE ?", "%#{params[:search]}%")
    # end_user_profile_names = EndUser.where("profile_name LIKE ?", "%#{params[:search]}%")

    search_results = []
    # search_results.push(hashtags)
    search_results.push(post_image_titles)
    search_results.push(post_image_captions)
    # search_results.push(end_user_profile_names)

    json = search_results.to_json
    # (include: [:post_images])
    render :json => json
  end
end

# artist = Item.joins(:artist).where("artist_name LIKE ?", "%#{params[:search]}%")
# track =  Item.joins(discs: :tracks).where("track_name LIKE ?", "%#{params[:search]}%")
# title = Item.where("title LIKE ?", "%#{params[:search]}%")
# merged_result = (artist | title)P
# @items = (merged_result | track)
# @items = Kaminari.paginate_array(@items).page(params[:page]).per(10)
# else
# @items = Item.page(params[:page]).per(10).reverse_order