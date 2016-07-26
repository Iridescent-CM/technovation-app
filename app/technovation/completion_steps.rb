class CompletionSteps
  include Enumerable

  def initialize(account)
    @account = account
  end

  def each(&block)
    ProfileCompletionSteps.registered_steps.each do |step|
      step.completion_status = @account.send(step.complete_condition) ? "complete" : "ready"
      block.call(step)
    end
  end
end
