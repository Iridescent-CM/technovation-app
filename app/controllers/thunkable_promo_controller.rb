class ThunkablePromoController < ApplicationController
  include Authenticated

  def show
    @thunkable_promo_image = ENV.fetch("THUNKABLE_PROMO_IMAGE")

    render "general_info/get_started_with_thunkable"
  end
end