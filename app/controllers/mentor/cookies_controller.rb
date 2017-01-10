module Mentor
  class CookiesController < MentorController
    def create
      cookies[params.fetch(:name)] = params.fetch(:value)
      head 200
    end
  end
end
