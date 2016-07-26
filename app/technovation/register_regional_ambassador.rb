module RegisterRegionalAmbassador
  def self.call(ambassador_account, context)
    if ambassador_account.save
      AdminMailer.pending_regional_ambassador(ambassador_account).deliver_later
      true
    else
      false
    end
  end

  def self.build(attributes)
    ambassador = RegionalAmbassadorAccount.new(attributes)
    ambassador.build_regional_ambassador_profile if ambassador.regional_ambassador_profile.blank?
    ambassador
  end
end
