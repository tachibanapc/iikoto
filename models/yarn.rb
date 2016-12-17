class Yarn < ActiveRecord::Base
  def op
    Post.where(number: self.number).first
  end
end
