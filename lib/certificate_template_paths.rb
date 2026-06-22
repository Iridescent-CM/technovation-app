module CertificateTemplatePaths
  FIRST_SEASON = 2026
  FIRST_JUDGE_TIER_SEASON = 2025

  LEGACY_JUDGE_TEMPLATES = {
    bronze_judge: "certified_judge",
    silver_judge: "head_judge",
    gold_judge: "judge_advisor",
    general_judge: "certified_judge"
  }.freeze

  module_function

  def for(recipient:, type:, season:)
    directory = "./lib/certs/#{season}"

    if season >= FIRST_SEASON
      filename = filename_for_2026(recipient: recipient, type: type)
      return "#{directory}/#{filename}" if filename
    end

    "#{directory}/#{legacy_filename(type, season: season)}.pdf"
  end

  def filename_for_2026(recipient:, type:)
    case type.to_sym
    when :ambassador_appreciation
      ambassador_filename(recipient)
    when :mentor
      "mentor.pdf"
    when :quarterfinalist
      "quaterfinalist.pdf"
    when :grand_prize_winner
      grand_prize_filename(recipient)
    else
      "#{type}.pdf"
    end
  end

  def ambassador_filename(recipient)
    if recipient.account.chapter_ambassador?
      "chapter_ambassador.pdf"
    else
      "club_ambassador.pdf"
    end
  end

  def grand_prize_filename(recipient)
    division = recipient.team&.division_name
    return unless division.present?

    "grand_prize_#{division}.pdf"
  end

  def legacy_filename(type, season:)
    case type.to_sym
    when :mentor
      "mentor_appreciation"
    when :grand_prize_winner
      "grand_prize_winner"
    when :bronze_judge, :silver_judge, :gold_judge
      if season >= FIRST_JUDGE_TIER_SEASON
        type.to_s
      else
        LEGACY_JUDGE_TEMPLATES.fetch(type.to_sym)
      end
    when :general_judge
      legacy_name = "general_judge"
      if File.exist?("./lib/certs/#{season}/#{legacy_name}.pdf")
        legacy_name
      else
        LEGACY_JUDGE_TEMPLATES.fetch(:general_judge)
      end
    else
      type.to_s
    end
  end
end
