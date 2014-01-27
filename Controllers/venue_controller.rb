class VenueController

  def self.show_all_json
    return Venue.find(:all).map { |x| x.to_json}.to_json
  end

end