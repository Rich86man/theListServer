require_relative '../Models/event'
class EventController

  def self.show_all_json
    return Event.all.to_json(:include => [:venue, :artists])
  end

  def self.show_count
    count = Event.all.count
    return "Events count : " + count.to_s
  end
end