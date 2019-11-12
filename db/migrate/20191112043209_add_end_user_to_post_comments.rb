class AddEndUserToPostComments < ActiveRecord::Migration[5.2]
  def change
    add_column :post_comments, :end_user_id, :integer
  end
end
