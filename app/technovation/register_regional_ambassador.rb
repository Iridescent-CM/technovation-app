module RegisterRegionalAmbassador
  def self.call(ambassador_account, context, mailer = AdminMailer)
    ambassador_account.save
  end

  def self.build(model, attributes)
    ambassador = model.new(attributes)
    ambassador.build_account if ambassador.account.blank?
    ambassador
  end
end
