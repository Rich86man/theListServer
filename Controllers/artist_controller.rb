require_relative '../Models/artist'
class ArtistController

  def self.show_all_json
    return Artist.find(:all).map { |x| x.as_json }.to_json
end