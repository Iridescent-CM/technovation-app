module VueHelper
  def escape_single_quotes(str)
    if str.blank?
      str
    else
      str.sub("'", "\\\\'")
    end
  end
end
