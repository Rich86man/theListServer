class CreateArtistEventJoin < ActiveRecord::Migration
  def up
    create_table :artists_events, :id => false do |t|
      t.integer :artist_id
      t.integer :event_id
    end
  end

  def down
    drop_table :artists_events
  end
end
