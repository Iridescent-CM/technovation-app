require 'fill_pdfs/regional_grand_prize'
require 'fill_pdfs/mentor_appreciation'
require 'fill_pdfs/completion'

module FillPdfs
  def self.call(participant, type)
    case type
    when :regional_grand_prize
      RegionalGrandPrize.(participant)
    when :completion
      Completion.(participant)
    when :mentor
      MentorAppreciation.(participant)
    else
      raise "Unsupported type #{type}"
    end
  end
end
