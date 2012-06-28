module UriScraper

  def self.sleep_on_timeout
    @sleep_on_timeout
  end

  def self.sleep_on_timeout= timeout
    @sleep_on_timeout = timeout
  end

  def self.get_response_body uri, attempt_count=0
    parsed_uri = URI(uri)

    begin
      response = Net::HTTP.get_response(parsed_uri)
    rescue Timeout::Error => e
      sleep (sleep_on_timeout || 0)
      if attempt_count.zero?
        return get_response_body(uri, attempt_count + 1)
      else
        return nil
      end
    end

    case response
    when Net::HTTPSuccess
      response.body

    when Net::HTTPRedirection
      get_response_body(response['location'])

    when Net::HTTPNotFound
      nil

    else
      nil
    end
  end

end
