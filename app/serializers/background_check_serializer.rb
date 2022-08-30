class BackgroundCheckSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :status

  attribute(:updated_at_epoch) do |b|
    (b.updated_at || 0).to_f * 1000
  end

  attribute :is_clear do |background_check|
    background_check.clear?
  end

  attribute :is_pending do |background_check|
    background_check.pending?
  end

  attribute :is_considering do |background_check|
    background_check.consider?
  end

  attribute :is_suspended do |background_check|
    background_check.suspended?
  end
end
