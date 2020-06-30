require 'nokogiri'
require 'httparty'
require 'JSON'
require 'csv'
require 'byebug'

def scraper
  url = "https://www.fantasypros.com/nfl/rankings/half-point-ppr-cheatsheets.php"
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  players = []
  players_listing = parsed_page.css('table#rank-data tr.player-row')
  
  players_listing.each do |player_listing|
    player = {
      player_name: player_listing.css('a span.full-name').text,
      team: player_listing.css('td.player-label small.grey').text,
      overall_rank: player_listing.css('td:first-child').text,
      positional_rank: player_listing.css('td:nth-of-type(4)').text,
      bye_week: player_listing.css('td:nth-of-type(5)').text
    }
    players << player
  end
  
  playersJS = players.to_json

  puts playersJS

  File.open('players.json', 'w') do |file|
    file << playersJS
  end

end

scraper