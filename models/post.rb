class Post < ActiveRecord::Base
  def file
    Image.find_by(post: self.number) 
  end
end
