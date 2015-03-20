class AddAttachmentAvatarToUsersAndTeams < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.attachment :avatar
    end

    change_table :teams do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :users, :avatar
    remove_attachment :teams, :avatar
  end
end
