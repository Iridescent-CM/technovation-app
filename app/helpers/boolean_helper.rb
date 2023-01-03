module BooleanHelper
  def humanize_boolean(boolean)
    case boolean
    when true
      "Yes"
    when false
      "No"
    when nil
      "-"
    end
  end
end
