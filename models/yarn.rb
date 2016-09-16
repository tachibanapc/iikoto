class Yarn < ActiveRecord::Base
  def op
    Post.where(yarn: self.number).first
  end
end
