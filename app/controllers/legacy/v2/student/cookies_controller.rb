module Legacy
  module V2
    module Student
      class CookiesController < StudentController
        def create
          cookies.permanent[params.fetch(:name)] = params.fetch(:value)
          head 200
        end
      end
    end
  end
end
