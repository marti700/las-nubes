class AddGoogleRefreshTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :google_refresh_token, :string
  end
end
