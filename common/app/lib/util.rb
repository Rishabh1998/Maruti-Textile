# General utility methods for application
# Author: Raj
class Util

  class << self

    # Check if the request is from a search bot
    #
    # Author:: Raj
    # Date:: 14/03/2016
    # Reviewed By::
    #
    # Params:
    # ++user_agent:: User agent from request headers
    # Returns true/false accordingly
    def is_search_bot?(user_agent)
      user_agent = '' if user_agent.nil?
      response = user_agent.match(/\b(Baidu|Baiduspider|Gigabot|Googlebot|thefind|webmeup-crawler.com|libwww-perl|lwp-trivial|msnbot|SiteUptime|Slurp|ZIBB|wget|ia_archiver|ZyBorg|bingbot|AdsBot-Google|AhrefsBot|FatBot|shopstyle|pinterest.com|facebookexternalhit|Twitterbot|crawler.sistrix.net|PolyBot|rogerbot|Pingdom|Mediapartners-Google|bitlybot|BlapBot|Ruby|Python|www.socialayer.com|Sogou|Scrapy|ShopWiki|Panopta|websitepulse|NewRelicPinger|Sailthru|JoeDog|SocialWire|CCBot|yacybot|Halebot|SNBot|SEOENGWorldBot|SeznamBot|libfetch|QuerySeekerSpider|A6-Indexer|PAYONE|GrapeshotCrawler|curl|ShowyouBot|NING|kraken|MaxPointCrawler|efcrawler|YisouSpider|BingPreview|MJ12bot)\b/i)
      return response.present?
    end

    # Formats phone number by stripping zeroes and replacing non numeric characters
    #
    # Author:: Raj
    # Date:: 14/03/2016
    # Reviewed By::
    #
    # Params:
    # +phone_number+:: Phone number to be formatted
    # +country_code+:: Country code for the phone number
    # Returns formatted phone number
    #
    def format_phone(phone_number, country_code)
      formatted_phone = phone_number.gsub(/[^0-9]/, '').gsub(/^0+/, '')
      "#{country_code}#{formatted_phone}"
    end

    # Pulls browser information from HTTP_USER_AGENT request header
    #
    # Author:: Raj
    # Date:: 14/06/2016
    # Reviewed By::
    #
    # Params:
    # +http_user_agent+:: HTTP_USER_AGENT header for the request
    #
    def detect_browser(http_user_agent)
      result = http_user_agent
      if result =~ /Safari/
        if result =~ /Chrome/
          version = result.split('Chrome/')[1].split(' ').first.split('.').first
          browser = 'Chrome'
        else
          browser = 'Safari'
          version = result.split('Version/')[1].split(' ').first.split('.').first
        end
      elsif result =~ /Firefox/
        browser = 'Firefox'
        version = result.split('Firefox/')[1].split('.').first
      elsif result =~ /Opera/
        browser = 'Opera'
        version = result.split('Version/')[1].split('.').first
      elsif result =~ /MSIE/
        browser = 'MSIE'
        version = result.split('MSIE')[1].split(' ').first
      end

      [browser,version]
    end

    # Calculates and returns the HMAC hash for data provided
    #
    # Author:: Raj
    # Date:: 24/11/2016
    # Reviewed By::
    #
    def get_hmac_hash(secret, data)
      algo = 'SHA1'
      _digest = OpenSSL::Digest.new(algo)
      OpenSSL::HMAC.hexdigest(_digest, secret, data)
    end

    def raw_number(mobile_number)
      return "" unless mobile_number.present?
      if mobile_number.starts_with?("+49")
        mobile_number.to_s[3..-1]
      elsif mobile_number.starts_with?("0049")
        mobile_number.to_s[4..-1]
      elsif mobile_number.starts_with?("0")
        mobile_number.to_s[1..-1]
      else
        mobile_number
      end
    end

    # check if the file is of type xlsx
    def is_xlx_file?(file_content_type)
      file_content_type == "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" or file_content_type=="application/zip" or file_content_type=="application/octet-stream" or file_content_type == "application/vnd.ms-excel"
    end

    # check if the file is of type csv
    def is_csv_file?(file_content_type)
      file_content_type == "text/plain"
    end

    def get_time_out(hour_time)
      @global_start_time = SystemConstant.find_by(key: "auto_bid_start_time").value
      @global_stop_time = SystemConstant.find_by(key: "auto_bid_stop_time").value
      last_day_minutes = 0
      minutes_in_between_days = 0
      business_minutes_in_a_day = (@global_stop_time.to_time - @global_start_time.to_time)/60
      today_minutes = (@global_stop_time.to_time - Time.now)/60
      if today_minutes < hour_time*60
        last_day_minutes = (hour_time*60- today_minutes)%business_minutes_in_a_day
        minutes_in_between_days = ((hour_time*60- today_minutes)/business_minutes_in_a_day).to_i*24*60
        if last_day_minutes!=0
          last_day_minutes += (24*60 - business_minutes_in_a_day)
        end
      else
        today_minutes = hour_time*60
      end
      return (today_minutes+last_day_minutes+minutes_in_between_days).minutes.from_now
    end

    def is_in_business_hour
      @global_start_time = SystemConstant.find_by(key: "auto_bid_start_time").value
      @global_stop_time = SystemConstant.find_by(key: "auto_bid_stop_time").value
      Time.now <= @global_stop_time.to_time && Time.now >= @global_start_time.to_time
    end

    def get_decoded_string(description)
      decoded_str = description
      if decoded_str.present?
        decoded_str.gsub!(/\\n\\t/, "")
        decoded_str.gsub!(/\\n/, "<br>")

        decoded_str.gsub!(/\\u(.{4})/) do |match|
          [$1.to_i(16)].pack('U')
        end
        decoded_str
      end
    end

    # Weekday number map
    #
    # Author:: Raj
    # Date:: 15/12/2017
    # Reviewed By::
    #
    def week_days
      {
          "1" => 'mon',
          "2" => 'tue',
          "3" => 'wed',
          "4" => 'thu',
          "5" => 'fri',
          "6" => 'sat',
          "7" => 'sun'
      }
    end
  end
end
