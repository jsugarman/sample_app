class RemoveRememberTokenFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :remember_token, :string
    # remove_index :users, :remember_token
  end
end