class KSIParser < Parser

  BASE_URL = 'http://ksi.ii.uj.edu.pl/'.freeze

  def parse
    page = agent.get(BASE_URL).parser
    news_nodes = page.css('.post')
    news_nodes.map do |news_node|
      link = news_node.at_css('.entry-title a')
      {
        title:      link.text,
        origin_url: link['href'],
        posted_at:  get_date(news_node),
        content:    get_content(news_node)
      }
    end
  end

  private

  def get_date(news_node)
    datetime_text = news_node.at_css('.entry-date')['datetime']
    Time.strptime(datetime_text, '%Y-%m-%d')
  end

  def get_content(news_node)
    content = news_node.at_css('.entry-content')
    strip_line_breaks(content)
  end

end
