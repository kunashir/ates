class AddProviderToAuthIdenties < ActiveRecord::Migration[7.0]
  def change
    add_column :auth_identies, :provider, :text
  end
end
