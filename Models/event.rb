class Event < ActiveRecord::Base
  has_and_belongs_to_many :artists
  belongs_to :venue


  validates :venue, :presence => true
  validates_uniqueness_of :event_date, :scope => :venue
  validates_presence_of :artists
end