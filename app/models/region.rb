class Region < ActiveRecord::Base
  enum division: {
    ms: 0,
    hs: 1,
    x: 2,
  }

  def division_description
    case
      when ms?
        'Middle School'
      when hs?
        'High School'
      else
        'Invalid Division'
    end
  end

  def name
    "#{division_description} - #{region_name}"
  end
end
