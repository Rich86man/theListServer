#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'
require 'pry'
require_relative 'Models/artist'
require_relative 'Models/event'
require_relative 'Models/venue'


class TheList
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
    
      children = elem.children.css('a')
    
      bands = children.select{|link| link['href'] and link['href'].include? "by-band" }.collect { |link| link.text } 
      venue = children.select{|link| link['href'] and link['href'].include? "by-club" }.collect{ |link| link.text }

    
      event['day'] = day
      event['bands'] = bands
      event['venues'] = venue
      events.push(event)
    }
    return events
  end

  def self.printEvents(events)
    string = ""
    events.each { |event| 
      bandsString = event["bands"].join(',')
      venuesString = event["venues"].join(',')
      string << "<p>These bands : #{bandsString} are playing at #{venuesString} on #{event["day"]}\n</p>"   
    }
    return string
  end

  def self.printPages(num)
    string = ""
    for i in 0..num
      string << printEvents(eventsOnPage(i))
    end
    return string
  end

  def self.fetchRecent

    events = [];
    for i in 0..5
      events << TheList.eventsOnPage(i)
    end
    events = events.flatten()

    for event in events
      venue = Venue.find_or_create_by(:name => event['venues'][0])
      date = Date.strptime(event['day'], '%a %b %d')
      newEvent = Event.create(:event_date => date, :venue => venue)
      if !newEvent.valid?
        puts "found duplicate"
        next
      end

      for band in event['bands']
        newEvent.artists.push(Artist.find_or_create_by(:name => band))
      end


    end
    return "success"
  end

end



