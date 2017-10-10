module Student
  class CookiesController < StudentController
    def create
      cookies.permanent[params.fetch(:name)] = params.fetch(:value)
      render json: {}
    end
  end
end
