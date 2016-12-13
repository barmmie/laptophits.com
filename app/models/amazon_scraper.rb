class AmazonScraper
  attr_reader :url
  attr_writer :current_proxy, 

  def initialize(url)
    @url = url
    @@proxy_list ||= refresh_proxy_list
  end

  def proxy_list
    @@proxy_list
  end

  def current_proxy
    @current_proxy ||= proxy_list.first
  end

  def parsed_page
    @parsed_page ||= Nokogiri::HTML(raw_page)
  end

  def refresh_proxy_list
    proxy_list_url = "http://www.publicproxyservers.com/proxy/list_rating1.html"
    Nokogiri::HTML(RestClient.get(proxy_list_url, headers: {})).css('.first a').map(&:text)
  end

  def next_proxy_server
    self.current_proxy = proxy_list[(proxy_list.index(current_proxy) + 1) % proxy_list.length]
  end

  def raw_page
    begin
      RestClient.proxy = current_proxy
      RestClient.get(url, user_agent: ('a'..'z').to_a.shuffle[0,64].join )
    rescue RestClient::ServiceUnavailable
      retry unless next_proxy_server == proxy_list.first
    end
  end

  def technical_details
    spec_table = parsed_page.css('#productDetails_techSpec_section_1, #productDetails_techSpec_section_2').css('tr')

    spec_table.map do |row|
      [row.css('th').text.strip, row.css('td').text.strip]
    end.to_h
  end
end
