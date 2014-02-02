#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'pry'
require_relative 'Models/artist'
require_relative 'Models/event'
require_relative 'Models/venue'

class String
  def numeric?
    Float(self) != nil rescue false
  end
end

class TheList

  NUM_RECENT_PAGES = 5

  def self.eventsOnPage(num)
    doc = Nokogiri::HTML(open("http://www.foopee.com/punk/the-list/by-date.#{num}.html"))
    events = []

    listElements = doc.css('li')
    day = ""
    listElements.each { |elem|

      if elem.css('a[name]').count > 0
        day = elem.css('a[name]')[0].text
        next
      end
      event = {}

      
      hour = ""
      price = 0
      ageLimit = ""
      reccomendationLevel = 0
      pitWarning = false
      sellout = false
      noInOut = false
      strings = elem.children.last.inner_text.split(' ')
      strings.each { |string| 
        if string.include? ('$') and string.tr("$", "").numeric?
          price = string.tr("$", "")
          next
        end
        
        if string.downcase.include? ('pm') or string.downcase.include? ('am')
          hour = string
          next
        end
        
        if string.downcase.include? ('a/a') or (string.length < 4 or string.include? ('+')) or string.numeric?
          ageLimit = string
          next
        end
          
        if string == "*" or string == "**" or string == "***" or string == "****" or string == "*****"
          reccomendationLevel = string.length
          next
        end
        
        if string == "@"
          pitWarning = true
          next
        end
        
        if string == "$"
          sellout = true
          next
        end
        
        if string == "#"
          noInOut = true
          next
        end
      }
      
      children = elem.children.css('a')

      bands = children.select{|link| link['href'] and link['href'].include? "by-band" }.collect { |link| link.text }
      venue = children.select{|link| link['href'] and link['href'].include? "by-club" }.collect{ |link| link.text }
      
      event['noInOut'] = noInOut
      event['sellout'] = sellout
      event['pitWarning'] = pitWarning
      event['recommendation'] = reccomendationLevel
      event['hour'] = hour 
      event['price'] = price 
      event['day'] = day + hour
      event['bands'] = bands
      event['venues'] = venue
      events.push(event)
    }
    return events
  end

  # TODO: move this out to a helper file, not sure what the best
  # practice is for that with Sinatra
  def self.pluralize_to_be(count)
    count > 1 ? "are" : "is"
  end

  def self.printEvents(events)
    string = ""
    events.each { |event|
      bandsString = event["bands"].join(', ')
      venuesString = event["venues"].join(', ')
      string << "<p>#{bandsString} #{pluralize_to_be(event["bands"].count)} playing at #{venuesString} on #{event["day"]}\n</p>"
    }
    return string
  end

  def self.printPages(num=1)
    string = ""
    num.times { |i| string << printEvents(eventsOnPage(i)) }

    return string
  end

  def self.fetchRecent
    events = []
    NUM_RECENT_PAGES.times { |i| events << TheList.eventsOnPage(i) }

    events.flatten.each do |event|
      venue = Venue.find_or_create_by(:name => event['venues'][0])
      date = DateTime.parse(event['day'])
      bands = []
      event['bands'].each do |band|
        bands.push(Artist.find_or_create_by(:name => band))
      end
      
      newEvent = Event.create(:event_date => date, 
                              :venue => venue,
                              :noInOutWarning => event['noInOut'], 
                              :sellOutWarning => event['sellout'], 
                              :pitWarning => event['pitWarning'], 
                              :recommendation => event['recommendation'], 
                              :hour => event['hour'], 
                              :price => event['price'],
                              :artists => bands)
      if !newEvent.valid?
        puts "found duplicate"
        next
      end


    end
    return "success"
  end

end



