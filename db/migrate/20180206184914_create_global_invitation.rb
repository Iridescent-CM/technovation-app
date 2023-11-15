class CreateGlobalInvitation < ActiveRecord::Migration[5.1]
  class GlobalInvitation < ActiveRecord::Base
    has_secure_token :token
  end

  def up
    puts GlobalInvitation.create!.token
  end
end
