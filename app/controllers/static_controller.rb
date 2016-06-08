class StaticController < ApplicationController
  def index
    @view = StaticView.new
  end

  private
  class StaticView
    def division_names
      DivisionsDecorator.new(Division.all).collect(&:name).to_sentence
    end

    def region_names
      Region.pluck(:name).to_sentence
    end

    def current_season_year
      Season.current.year
    end
  end
end
