class NullConsentWaiver < NullObject
  def id
    0
  end

  def signed_at
    false
  end

  def signed?
    false
  end

  def status
    "none"
  end

  def destroy
    false
  end

  def paranoid?
    false
  end
end
