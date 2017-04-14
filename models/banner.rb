class Banner
  def self.pick
    if !File.directory? "public/banners/"
      return nil
    end

    banners = Dir.entries('public/banners/').reject { |f|
      File.directory? f
    }

    if banners.empty?
      nil
    else
      banners.shuffle.first.prepend('/banners/')
    end
  end
end
