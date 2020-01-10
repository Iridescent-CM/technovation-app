module StringHelper
  def escape_single_quotes(str)
    if str.blank?
      str
    else
      str.gsub("'", "\\\\'")
    end
  end
end
