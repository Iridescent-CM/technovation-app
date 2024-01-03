class FauxAccount
  def initialize(real_account: Account.new, methods_with_return_values: {})
    @real_account = real_account

    methods_with_return_values.each do |method_name, return_value|
      self.class.define_method method_name do
        return_value
      end
    end
  end

  def method_missing(method, *_args, &_block)
    real_account.respond_to?(method) ? nil : super
  end

  private

  attr_reader :real_account
end
