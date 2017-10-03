class RegenerateNullReviewTokensOnJoinRequests < ActiveRecord::Migration[5.1]
  def up
    JoinRequest.where(review_token: [nil, ""]).find_each do |j|
      j.regenerate_review_token
    end
  end
end
