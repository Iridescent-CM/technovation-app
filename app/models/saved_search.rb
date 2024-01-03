require "uri"

class SavedSearch < ApplicationRecord
  belongs_to :searcher, polymorphic: true

  validates :param_root, presence: true

  validates :name, :search_string, presence: true,
    uniqueness: {scope: [:param_root, :searcher_type, :searcher_id]}

  scope :for_param_root, ->(root_name) {
    where(param_root: root_name)
  }

  before_validation -> {
    self.search_string = search_string.gsub("&&", "")
  }

  def self.default_or_saved_search_params?(params, root, searcher)
    grid = params.dup.to_unsafe_h[root] || {}

    grid[:season] ||= []
    grid[:scope_names] ||= []
    grid[:column_names] ||= []

    existing_values = searcher.saved_searches
      .for_param_root(root)
      .map(&:to_search_params)
      .map { |h| h.values.flatten.sort }

    existing_values.include?(grid.values.flatten.sort) or (
      grid[:season] = (
        Array(grid[:season]) - [Season.current.year.to_s]
      )

      grid[:scope_names].clear if grid[:scope_names].one?

      grid.values.all? { |v| v.empty? }
    )
  end

  def to_search_params
    # CONVERT
    #   FROM foo=bar&baz=qux&baz=quux
    #   TO [["foo", "bar"], ["baz", "qux"], ["baz", "quux"]]
    #
    decoded = URI.decode_www_form(search_string)
    #
    # CONVERT
    #   FROM [["foo", "bar"], ["baz", "qux"], ["baz", "quux"]]
    #   TO [{"foo" => "bar"}, {"baz => "qux"}, {"baz" => "quux"}]
    #
    hash_pairs = decoded.map { |pair| Hash[*pair] }
    #
    # CONVERT
    #   FROM [{"foo" => "bar"}, {"baz => "qux"}, {"baz" => "quux"}]
    #   TO { "foo" => "bar", "baz" => ["qux", "quux"] }
    #
    fixed = hash_pairs.inject { |a, b| a.merge(b) { |*i| i[1, 2] } }

    fixed.each do |k, v|
      fixed[k] = v.is_a?(Array) ? v.flatten : v
    end

    fixed
  end

  def matches_params?(params)
    mine = to_search_params.values.flatten.sort
    theirs = params.values.flatten.sort
    mine == theirs
  end
end
