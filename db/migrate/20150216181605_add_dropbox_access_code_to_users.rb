class AddDropboxAccessCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :dropbox_access_code, :string
  end
end
