class Venue < ActiveRecord::Base
  extend Geocoder::Model::ActiveRecord
  has_many :events
  geocoded_by :name

  validates_uniqueness_of :name

  after_validation :geocode, :if => :name_changed?
end