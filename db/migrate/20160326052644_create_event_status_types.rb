class CreateEventStatusTypes < ActiveRecord::Migration
  def change
    create_table :event_status_types do |t|
      t.boolean :is_active
      t.string :name

      t.timestamps null: false
    end
  end
end
