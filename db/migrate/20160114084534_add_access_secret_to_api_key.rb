class AddAccessSecretToApiKey < ActiveRecord::Migration
  def change
      add_column :api_keys,:access_secret, :string
  end
end
