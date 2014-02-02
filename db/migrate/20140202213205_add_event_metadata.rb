class AddEventMetadata < ActiveRecord::Migration
  def up
    add_column :events, :hour, :string
    add_column :events, :recommendation, :integer
    add_column :events, :pitWarning, :boolean
    add_column :events, :sellOutWarning, :boolean
    add_column :events, :noInOutWarning, :boolean
  end

  def down
    remove_column :events, :hour
    remove_column :events, :recommendation
    remove_column :events, :pitWarning
    remove_column :events, :sellOutWarning
    remove_column :events, :noInOutWarning
  end
end
