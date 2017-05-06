module Legacy
  module V2
    module Student
      class HonorCodeAgreementsController < StudentController
        include HonorCodeAgreementController
      end
    end
  end
end
