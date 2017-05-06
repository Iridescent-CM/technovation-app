module Legacy
  module V2
    module Mentor
      class CookiesController < MentorController
        def create
          cookies.permanent[params.fetch(:name)] = params.fetch(:value)
          head 200
        end
      end
    end
  end
end
