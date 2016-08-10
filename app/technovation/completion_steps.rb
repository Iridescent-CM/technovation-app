require "./app/technovation/profile_completion/step"
require "./app/technovation/profile_completion/link"

class CompletionSteps
  include Enumerable

  attr_reader :account
  attr_reader :steps

  def initialize(account)
    @account = account
    @steps = ProfileCompletion.registered_steps(@account)
    set_account_options_on_steps
  end

  def each(&block)
    if block_given?
      steps.each { |step| block.call(step) }
    else
      steps.each
    end
  end

  def unlocked?(path)
    if step = steps.detect { |s| s.unlocks?(account, path) }
      not step.future?
    else
      true
    end
  end

  private
  def set_account_options_on_steps
    steps.each { |step| step.set_account_options(account) }
  end
end
