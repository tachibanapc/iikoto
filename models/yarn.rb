class Yarn < ActiveRecord::Base
  def op
    Post.where(number: self.number).first
  end

  def replies
    Post.where(yarn: self.number)[1..-1]
  end

  def images
    self.replies.select { |post|
      !post.file.nil?
    }
  end

  def reply_limit?
    self.replies.length > $CONFIG[:reply_limit]
  end

  def image_limit?
    self.images.length > $CONFIG[:image_limit]
  end
end
