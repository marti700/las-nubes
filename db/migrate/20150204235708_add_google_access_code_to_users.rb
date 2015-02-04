class AddGoogleAccessCodeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_access_code, :string
  end
end
