module Judging
  class SetContestRankFromCsv
    class MissingSubmissionIdColumn < StandardError; end

    Result = Struct.new(:updated_count, keyword_init: true)

    def initialize(csv_file:, rank:)
      @csv_file = csv_file
      @rank = rank
    end

    def call
      submission_ids = []

      SmarterCSV.process(csv_file, csv_options) do |chunk|
        submission_ids.concat(
          chunk.filter_map { |row| row[:submission_id].presence }
        )
      end

      updated_count = SetContestRank.new(
        rank: rank,
        submission_ids: submission_ids
      ).call

      Result.new(updated_count: updated_count)
    rescue SmarterCSV::MissingKeys
      raise MissingSubmissionIdColumn
    end

    private

    attr_reader :csv_file, :rank

    def csv_options
      {
        chunk_size: 200,
        required_keys: [:submission_id],
        col_sep: csv_col_sep
      }
    end

    def csv_col_sep
      first_line = csv_file.read
      csv_file.rewind

      first_line.include?(";") ? ";" : ","
    end
  end
end
