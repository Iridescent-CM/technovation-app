class Document < ActiveRecord::Base
  belongs_to :signer, polymorphic: true

  def signed?
    signed_at.present?
  end
end
