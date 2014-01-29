require_relative '../Models/artist'
class ArtistController

  def self.show_all_json
    return Artist.all.to_json
  end
end