require "./app/technovation/profile_completion/step"
require "./app/technovation/profile_completion/link"

class CompletionSteps
  include Enumerable

  def initialize(account)
    @account = account
  end

  def each(&block)
    ProfileCompletion.registered_steps(@account).each do |step|
      step.set_account_options(@account)
      block.call(step)
    end
  end
end
