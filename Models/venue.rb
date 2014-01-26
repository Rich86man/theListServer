class Venue < ActiveRecord::Base
  has_many :events

  validates_uniqueness_of :name
end