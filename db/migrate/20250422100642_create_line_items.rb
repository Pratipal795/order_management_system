class CreateLineItems < ActiveRecord::Migration[7.2]
  def change
    create_table :line_items do |t|
      t.references :order, null: false, foreign_key: true
      t.string :sku
      t.integer :quantity
      t.boolean :original, default: true

      t.timestamps
    end
  end
end
