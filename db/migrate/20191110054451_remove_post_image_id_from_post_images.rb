class RemovePostImageIdFromPostImages < ActiveRecord::Migration[5.2]
  def change
    remove_column :post_images, :post_image_id, :string
    remove_column :post_images, :user_id, :integer
  end
end
