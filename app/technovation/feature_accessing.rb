require "active_model"

class FeatureAccessing
   include ActiveModel::Model
   include ActiveModel::Validations

   attr_accessor :student_signup

   validates :student_signup,
     presence: true,
     inclusion: {
       in: %w{on off yes no true false} + [true, false],
       allow_blank: true
     }

   def save
     false
   end
end
