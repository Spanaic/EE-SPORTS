class AddColumnToPostImage < ActiveRecord::Migration[5.2]
  def change
    add_column :post_images, :image_name, :string
  end
end
