require 'digest/sha1'

class RssArticle < ActiveRecord::Base
  belongs_to :rss_feed
  validates :guid, presence: true
  validates :title, presence: true

  def absolute_link
    return link if link =~ URI::regexp
    uri = URI.parse(rss_feed.url)
    "#{uri.scheme}://#{uri.host}#{link}"
  end

  class << self
    def from_item(item)
      new(title: item.title, link: item.link, description: item.description, author: set_author(item),
          time: set_time(item), guid: guid_from_item(item))
    end

    def set_author(item)
      item.name || item.author || item.dc_creator
    end

    def set_time(item)
      date = (item.published || item.pubDate || item.dc_date || Time.current).to_s
      time = Time.parse(date).utc
      time = Time.current if time > Time.current
      time
    end

    def guid_from_item(item)
      Digest::SHA1.hexdigest([item.title, item.link, item.description].compact.join('|'))
    end
  end
end
