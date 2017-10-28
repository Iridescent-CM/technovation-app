require 'uri'

class SavedSearch < ApplicationRecord
  belongs_to :searcher, polymorphic: true

  validates :param_root, presence: true

  validates :name, :search_string, presence: true,
    uniqueness: { scope: [:param_root, :searcher_type, :searcher_id] }

  scope :for_param_root, ->(root_name) {
    where(param_root: root_name)
  }

  before_validation -> {
    self.search_string = search_string.gsub('&&', '')
  }

  def self.default_or_saved_search_params?(params, searcher)
    accounts_grid = params.to_unsafe_h[:accounts_grid] || {}

    accounts_grid[:season] ||= []
    accounts_grid[:scope_names] ||= []

    existing_strs = searcher.saved_searches
      .for_param_root(:accounts_grid)
      .pluck(:search_string)
      .map { |s| Hash[URI.decode_www_form(s)] }

    current_encoded = URI.encode_www_form(accounts_grid).gsub('&&', '')

    current_decoded = Hash[URI.decode_www_form(current_encoded)]

    existing_strs.include?(current_decoded) or (
      accounts_grid[:season] = Array(accounts_grid[:season]) -
        [Season.current.year.to_s]

      accounts_grid[:scope_names].clear if accounts_grid[:scope_names].one?

      accounts_grid.values.all? { |v| v.empty? }
    )
  end

  def search_string_matches_params?(params)
    mine = Hash[URI.decode_www_form(search_string)]
    theirs_encoded = URI.encode_www_form(params.to_unsafe_h).gsub('&&', '')
    theirs_decoded = Hash[URI.decode_www_form(theirs_encoded)]

    mine == theirs_decoded
  end
end
