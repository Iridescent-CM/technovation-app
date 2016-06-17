class Role < ActiveRecord::Base
  enum name: %i{judge admin student no_role}

  names.each do |role, value|
    define_singleton_method role do
      find_or_create_by(name: value)
    end
  end

  def self.registerable_name(value)
    names.reject { |k, _| k == "admin" }
         .select { |_, v| v == Integer(value) }.keys.first
  end
end
