class Role < ActiveRecord::Base
  enum name: %i{judge}

  def self.judge
    find_or_create_by(name: names[:judge])
  end
end
