module Coach
  class SignupsController < Mentor::SignupsController
    private
    def model_name
      "coach"
    end
  end
end
