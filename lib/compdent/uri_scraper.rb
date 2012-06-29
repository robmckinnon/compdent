module UriScraper

  def self.sleep_on_timeout
    @sleep_on_timeout
  end

  def self.sleep_on_timeout= timeout
    @sleep_on_timeout = timeout
  end

  def self.get_response_body uri
    response = get_response(URI(uri))
    handle_response response
  end

  def self.get_response uri
    begin
      do_get_response(uri)
    rescue Timeout::Error
      sleep(sleep_on_timeout || 0)
      do_get_response(uri) rescue Timeout::Error
    end
  end

  def self.do_get_response(uri)
    Net::HTTP.get_response(uri)
  end

  def self.handle_response response
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
