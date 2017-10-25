module Mentor
  class CookiesController < MentorController
    def create
      set_cookie(
        params.fetch(:name),
        params.fetch(:value),
        permanent: true
      )

      render json: {}
    end
  end
end
