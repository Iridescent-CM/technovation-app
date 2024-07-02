class AddIndexToMembershipsMemberType < ActiveRecord::Migration[6.1]
  def change
    add_index :memberships, :member_type
  end
end
