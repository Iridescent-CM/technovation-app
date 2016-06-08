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

    def scoring_rubric
      ScoreCategory.all.map { |c|
        [c.name,
         c.score_attributes.flat_map(&:label),
         c.score_attributes.flat_map { |a| a.score_values.map(&:label) }].join('<br>')
      }.join('<br>').html_safe
    end
  end
end
