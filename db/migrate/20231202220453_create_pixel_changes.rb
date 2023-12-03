class CreatePixelChanges < ActiveRecord::Migration[7.1]
  def change
    create_table :pixel_changes do |t|
      t.references :user, null: false
      t.references :painting, null: false, index: false
      t.integer :row, limit: 2, null: false
      t.integer :col, limit: 2, null: false
      t.binary :color, limit: 3, null: false

      t.timestamps

      t.index [:painting_id, :created_at]
    end
  end
end
