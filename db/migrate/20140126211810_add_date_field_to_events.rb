class AddDateFieldToEvents < ActiveRecord::Migration
  def up
    add_column :events, :event_date, :datetime
  end

  def down
    remove_column :events
  end
end
