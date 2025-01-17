class NullChapterable < NullObject
  def primary_contact
    NullAccount.new
  end
end
