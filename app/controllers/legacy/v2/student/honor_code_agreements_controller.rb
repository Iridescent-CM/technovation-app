module Legacy
  module V2
    module Student
      class HonorCodeAgreementsController < StudentController
        include Concerns::HonorCodeAgreementController
      end
    end
  end
end
