class CreateGlobalInvitation < ActiveRecord::Migration[5.1]
  def up
    puts GlobalInvitation.create!.token
  end
end
