require_relative '../Models/event'
class EventController

  def self.show_all_json
    return Event.all.to_json(:include => [:venue, :artists])
  end

end