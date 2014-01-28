require_relative '../Models/venue'
class VenueController

  def self.show_all_json
    return Venue.all.to_json
  end

end