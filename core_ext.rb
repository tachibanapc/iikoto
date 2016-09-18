class Time
  def elapsed
    elapsed = (Time.now - self).to_i
    name = if 60 > elapsed
             'second'
           elsif 60 > elapsed /= 60
             'minute'
           elsif 60 > elapsed /= 60
             'hour'
           elsif 24 > elapsed /= 24
             'day'
           elsif 7 > elapsed / 7
             elapsed /= 7
             'week'
           elsif 30 > elapsed / 30
             elapsed /= 30
             'month'
           else
             elapsed /= 365
             'year'
           end

    name += 's' if elapsed > 1
    "#{elapsed} #{name} ago"
  end
end
