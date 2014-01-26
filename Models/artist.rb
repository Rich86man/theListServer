class Artist < ActiveRecord::Base
  has_and_belongs_to_many :events
  validates_uniqueness_of :name
end