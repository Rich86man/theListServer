#!/usr/bin/env ruby
require 'nokogiri'
require 'open-uri'


class TheList
  def self.eventsOnPage(num)
    doc = Nokogiri::HTML(open("http://www.foopee.com/punk/the-list/by-date.#{num}.html"))
    events = []
  
    listElements = doc.css('li')
    day = ""
    listElements.each { |elem| 

      if elem.css('a[name]').count > 0
        day = elem.css('a[name]')[0].text
      end 
      event = {}
    
      children = elem.children.css('a')
    
      bands = children.select{|link| link['href'] and link['href'].include? "by-band" }.collect { |link| link.text } 
      venue = children.select{|link| link['href'] and link['href'].include? "by-club" }.collect{ |link| link.text }
    
    
      event["day"] = day
      event["bands"] = bands
      event["venues"] = venue;
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

end



