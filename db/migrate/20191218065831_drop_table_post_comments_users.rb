class DropTablePostCommentsUsers < ActiveRecord::Migration[5.2]
  def change
    drop_table :post_comments_users
  end
end
