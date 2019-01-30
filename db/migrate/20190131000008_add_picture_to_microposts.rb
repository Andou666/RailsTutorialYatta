class AddPictureToMicroposts < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :profile, :string
    add_column :microposts, :picture, :string
  end
end
