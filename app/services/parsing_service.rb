class ParsingService

  def initialize(data_sources)
    @data_sources = data_sources
  end

  def call
    @data_sources.each do |data_source|
      data = send("#{data_source.parser_name}_parser").parse
      data.each do |attrs|
        data_source.posts.find_or_create_by(posted_at: attrs[:posted_at], title: attrs[:title]) do |p|
          p.assign_attributes(attrs)
        end
      end
    end
  end

  private

  def wmii_parser
    @wmii_parser ||= WMIIParser.new
  end

  def ksi_parser
    @ksi_parser ||= KSIParser.new
  end
end
