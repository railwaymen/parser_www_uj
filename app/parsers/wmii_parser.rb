class WMIIParser < Parser

  BASE_URL = 'http://www.matinf.uj.edu.pl/wydzial/aktualnosci'.freeze

  def parse
    page = agent.get(BASE_URL)
    news_links = page.links_with(class: /box/)
    news_links.map do |news_link|
      news_page = news_link.click.parser
      {
        title:      get_title(news_page),
        origin_url: news_link.href,
        posted_at:  get_date(news_page),
        content:    get_content(news_page)
      }
    end
  end

  private

  def get_title(news_page)
    news_page.at_css('#tresc h1').text
  end

  def get_date(news_page)
    date_text = news_page.css('#tresc div:last').at_css('b').text
    Time.strptime(date_text, '%d.%m.%Y')
  end

  def get_content(news_page)
    content = news_page.at_css('#tresc')
    content.at_css('h1').remove
    content.css('div:last').remove
    strip_line_breaks(content)
  end

end
