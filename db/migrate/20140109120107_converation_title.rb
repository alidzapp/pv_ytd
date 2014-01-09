class ConverationTitle < ActiveRecord::Migration
  def change
    add_column :convertions, :title, :string
  end
end
