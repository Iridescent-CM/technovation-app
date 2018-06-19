module OverrideCertificate
  def self.call(account, certificate_type_as_integer)
    account.current_certificates.destroy_all
    account.update_column(
      :override_certificate_type,
      certificate_type_as_integer,
    )
  end
end