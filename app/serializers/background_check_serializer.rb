class BackgroundCheckSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  attributes :status

  attribute(:updated_at_epoch) do |b|
    (b.updated_at || 0).to_f * 1000
  end

  attribute :is_clear,       &:clear?
  attribute :is_pending,     &:pending?
  attribute :is_considering, &:consider?
  attribute :is_suspended,   &:suspended?
end