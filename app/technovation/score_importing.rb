require 'csv'

class ScoreImporting
  def initialize(file_path, score_repository)
    @io_source = File.open(file_path)
    @repository = score_repository
  end

  def import_scores
    CSV.foreach(@io_source, headers: true) do |row|
      @repository.from_csv(row.to_h)
    end
  end
end
