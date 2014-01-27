require_relative '../Models/event'
class EventController

  def self.show_all_json
    return Event.find(:all).map { |x| x.as_json(:include => [:venue, :artists])}.to_json
  end

end