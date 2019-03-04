class DataAnalysis
  include ActionView::Helpers::NumberHelper

  attr_reader :user

  def self.for(user, analysis_type)
    "DataAnalyses::#{analysis_type.to_s.camelize}DataAnalysis".constantize.new(user)
  end

  def initialize(user)
    @user = user
    init_data
  end

  def id
    Time.current.to_i
  end

  def data
    []
  end

  def datasets
    []
  end

  def totals
    {}
  end

  def urls
    []
  end

  private
  def show_percentage(num_collection, denom_collection)
    "(" +
      number_to_percentage(
        get_percentage(num_collection, denom_collection),
        precision: 0
      ) +
    ")"
  end

  def get_percentage(num_collection, denom_collection, passed_opts = {})
    return 0 if denom_collection.count.zero?

    options = {
      round: 0,
    }.merge(passed_opts)

    ((num_collection.count / denom_collection.count.to_f) * 100)
      .round(options[:round])
  end

  def url_helper
    Rails.application.routes.url_helpers
  end
end