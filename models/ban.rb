class Ban < ActiveRecord::Base
  def self.banned? ip
    !Ban.where(ip: ip).empty?
  end

  # Deletes all posts and yarns by a given IP
  def self.delete_by ip
    Post.where(ip: ip).map { |post|
      yarn = Yarn.find_by(number: post.number)

      if !yarn.nil?
        yarn.completely_delete
      else
        Yarn.find_by(number: post.yarn).correct_updated
        post.delete
      end
    }
  end
end
