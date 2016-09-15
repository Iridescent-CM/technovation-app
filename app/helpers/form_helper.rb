module FormHelper
  def hidden_or_string(value)
    value.blank? ? :string : :hidden
  end
end
