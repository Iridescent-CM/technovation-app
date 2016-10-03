module Judge
  class BackgroundChecksController < JudgeController
    include BackgroundCheckController

    private
    def current_account
      current_judge
    end
  end
end
