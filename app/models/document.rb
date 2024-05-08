class Document < ActiveRecord::Base
  belongs_to :signer, polymorphic: true
end
