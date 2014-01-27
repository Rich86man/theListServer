require_relative 'Models/artist'
class ArtistController

  def self.show_all_json
    array = []
    for artist in Artist.find(:all)
      array << artist.to_json
    end
    return array.to_json
  end

end