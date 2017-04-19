class Post < ActiveRecord::Base
  def file
    Image.find_by(post: self.number)
  end

  def format_body
    self.body.gsub(/\>\>(?<you>\d+)/, '<a href="#p\k<you>">&gt;&gt;\k<you></a>')
      .gsub(/^\>(?<greentext>.+)$/, '<span class="quote">&gt;\k<greentext></span>')
  end
end
