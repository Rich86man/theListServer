class EventController

  def self.show_all_json
    return Event.find(:all, :include => :artists).map { |x| x.to_json}.to_json
  end

end