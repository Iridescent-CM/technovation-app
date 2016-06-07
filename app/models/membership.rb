class Membership < ActiveRecord::Base
  belongs_to :member, polymorphic: true
  belongs_to :joinable, polymorphic: true
end
