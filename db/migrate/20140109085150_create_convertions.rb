class CreateConvertions < ActiveRecord::Migration
  def change
    create_table :convertions do |t|

      t.timestamps
      t.integer :encoding_status, :integer, :default => 0
      t.string :url
      t.string :encoded_file
    end
  end
end
