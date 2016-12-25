class Image < ActiveRecord::Base
  def self.uuid
    SecureRandom.urlsafe_base64($CONFIG[:url_hash_size])
  end
end
