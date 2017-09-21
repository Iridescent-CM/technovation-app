class AddReviewTokenToJoinRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :join_requests, :review_token, :string
  end
end
