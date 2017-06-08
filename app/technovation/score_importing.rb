require 'csv'

class ScoreImporting
  def initialize(file_path, score_repository)
    @source = CSV.open(file_path).read
    @repository = score_repository
  end

  def headers
    @source[0]
  end

  def rows
    @source[1..-1]
  end
end
