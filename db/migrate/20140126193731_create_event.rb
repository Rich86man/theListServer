class CreateEvent < ActiveRecord::Migration
  def up
    create_table :events do |t|
      t.string  :name
      t.integer :price
      t.integer :venue_id
    end
  end

  def down
    drop_table :events
  end
end
