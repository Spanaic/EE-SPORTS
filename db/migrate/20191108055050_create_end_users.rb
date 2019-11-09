class CreateEndUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :end_users do |t|
      t.string :email
      t.string :name
      t.string :profile_name
      t.string :profile_image_name

      t.timestamps
    end
  end
end
