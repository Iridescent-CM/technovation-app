module Legacy
  module V2
    module Student
      class ProfileImageUploadConfirmationsController < StudentController
        include Concerns::ProfileImageUploadConfirmationController
      end
    end
  end
end
