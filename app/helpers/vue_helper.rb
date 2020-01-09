module VueHelper
  def escape_single_quotes(str)
    str.sub("'", "\\\\'")
  end
end
