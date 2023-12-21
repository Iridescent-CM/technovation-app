class ConsentSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :status, :signed_at

  attribute(:is_signed) do |consent|
    consent.signed?
  end

  attribute(:signed_at_epoch) do |consent|
    (consent.signed_at || 0).to_f * 1000
  end
end
