class AddReviewTokenToJoinRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :join_requests, :review_token, :string
    add_index :join_requests, :review_token, unique: true
  end
end
