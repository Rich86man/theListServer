class AddCanceledToEvents < ActiveRecord::Migration
  def up
    add_column :events, :canceled, :boolean, :default => false
  end

  def down
    remove_column :events, :canceled
  end
end
