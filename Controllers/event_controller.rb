require_relative '../Models/event'
class EventController

  def self.show_all_json
    return Event.where(:canceled => false).to_json(:include => [:venue, :artists])
  end

  def self.show_count
    count = Event.all.count
    return "Events count : " + count.to_s
  end
  
  def self.all_on_date(dateToFind)
    selected_date = Date.parse(dateToFind)
    # This will look for records on the given date between 00:00:00 and 23:59:59
    Event.where( :event_date => selected_date.change(:hour => 0)..selected_date.change(:hour => 24)).where(:canceled => false)
  end
  
  def self.show_all_json_with_date(dateToFind)
    self.all_on_date(dateToFind).to_json(:include => [:venue, :artists])
  end
  
  def self.show_deletions
    Event.where(:canceled => true).pluck(:id).to_json
  end
  
end