class CreatePainting < ActiveRecord::Migration[7.1]
  def change
    create_table :paintings do |t|
      t.references :user, null: false
      t.string :title
      t.integer :width, limit: 2, null: false
      t.integer :height, limit: 2, null: false

      t.timestamps
    end
  end
end
