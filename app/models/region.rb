class Region < ActiveRecord::Base
  enum division: {
    ms: 0,
    hs: 1,
    x: 2,
  }

  def name
    division = case
    when ms?
      'Middle School'
    when hs?
      'High School'
    else
      'Invalid Division'
    end

    division + ' - ' + region_name
  end
end
