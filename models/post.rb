class Post < ActiveRecord::Base
  def file
    Image.find_by(post: self.number) 
  end

  def formatBody
    self.body.sub(/\>\>(?<you>\d+)/, '<a href="#p\k<you>">>>\k<you></a>')
      .gsub(/(?!\>)\>(?<greentext>.+)/, '<span class="quote">>\k<greentext></span>')
  end
end
