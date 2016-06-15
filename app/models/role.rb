class Role < ActiveRecord::Base
  enum name: %i{judge admin no_role}

  def self.judge
    find_or_create_by(name: names[:judge])
  end

  def self.admin
    find_or_create_by(name: names[:admin])
  end

  def self.no_role
    find_or_create_by(name: names[:no_role])
  end
end
