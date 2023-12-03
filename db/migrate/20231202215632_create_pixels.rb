class CreatePixels < ActiveRecord::Migration[7.1]
  def change
    create_table :pixels do |t|
      t.references :painting, null: false, index: false
      t.integer :row, limit: 2, null: false
      t.integer :col, limit: 2, null: false
      t.binary :color, limit: 3, null: false

      t.timestamps

      t.index [:painting_id, :row, :col], unique: true
    end
  end
end
