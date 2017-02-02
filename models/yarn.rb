class Yarn < ActiveRecord::Base
  def op
    Post.where(number: self.number).first
  end

  def replies
    Post.where(yarn: self.number)[1..-1]
  end
end
