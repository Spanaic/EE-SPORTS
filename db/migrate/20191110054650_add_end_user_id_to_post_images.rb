class AddEndUserIdToPostImages < ActiveRecord::Migration[5.2]
  def change
    add_column :post_images, :end_user_id, :integer
  end
end
