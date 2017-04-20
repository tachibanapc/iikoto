class Post < ActiveRecord::Base
  def file
    Image.find_by(post: self.number)
  end

  def format_body
    Rack::Utils.escape_html(self.body).gsub(/\&gt;\&gt;(?<you>\d+)/, '<a href="#p\k<you>">&gt;&gt;\k<you></a>')
      .gsub(/^\&gt;(?<greentext>.+)$/, '<span class="quote">&gt;\k<greentext></span>')
  end
end
