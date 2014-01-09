class ConvertionToken < ActiveRecord::Migration
  def change
    add_column :convertions, :token, :string
  end
end
