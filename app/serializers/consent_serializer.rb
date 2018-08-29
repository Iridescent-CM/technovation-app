class ConsentSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :status

  attribute(:is_signed) do |consent|
    consent.signed?
  end
end