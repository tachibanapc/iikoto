require 'digest'

class User < ActiveRecord::Base
  def self.exists? username
    if User.find_by(username: username).nil?
      false
    else
      true
    end
  end

  def self.authorized?(username, password)
    user = User.find_by(username: username)

    if user.nil?
      return false
    end

    salt = user.salt
    digest = Digest::SHA512.hexdigest(password + salt)

    return (digest == user.password)
  end
end
