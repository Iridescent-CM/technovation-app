class RegenerateNullReviewTokensOnJoinRequests < ActiveRecord::Migration[5.1]
  def up
    JoinRequest.where(review_token: [nil, ""]).find_each do |j|
      token = SecureRandom.base58(24)
      j.update_columns(review_token: token)
    rescue ActiveRecord::RecordNotUnique
      token = SecureRandom.base58(24)
      j.update_columns(review_token: token)
    end
  end
end
