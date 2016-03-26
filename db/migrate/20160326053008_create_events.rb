class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.boolean :is_active
      t.string :title
      t.datetime :created_at
      t.text :description
      t.datetime :updated_at

      t.timestamps null: false
    end
  end
end
