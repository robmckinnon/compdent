module UriScraper

  extend self

  def sleep_on_timeout
    @sleep_on_timeout
  end

  def sleep_on_timeout= timeout
    @sleep_on_timeout = timeout
  end

  def get_response_body uri
    begin
      uri = URI(uri)
    rescue Exception => e
      puts e.to_s
    end

    if uri
      response = get_response(uri)
      handle_response response
    end
  end

  def get_response uri
    begin
      do_get_response(uri)
    rescue Timeout::Error
      sleep(sleep_on_timeout || 0)
      do_get_response(uri) rescue Timeout::Error
    rescue NoMethodError,EOFError,Exception => e
      puts e.to_s
      nil
    rescue SocketError => e
      puts e.to_s
      nil
    end
  end

  def do_get_response(uri)
    Net::HTTP.get_response(uri)
  end

  def handle_response response
    case response
    when Net::HTTPSuccess
      convert_response response.body
    when Net::HTTPRedirection
      get_response_body(response['location'])
    when Net::HTTPNotFound
      nil
    else
      nil
    end
  end

  def convert_response content
    if defined?(CharlockHolmes) || (require 'charlock_holmes')
      detector = CharlockHolmes::EncodingDetector.new
      detection = detector.detect(content)
      unless detection[:encoding] == 'UTF-8'
        content = CharlockHolmes::Converter.convert content, detection[:encoding], 'UTF-8'
      end
    end
    content
  end
end
