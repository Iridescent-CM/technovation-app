module CertificateTemplatePaths
  FIRST_SEASON = 2026

  module_function

  def for(recipient:, type:, season:)
    directory = "./lib/certs/#{season}"

    if season >= FIRST_SEASON
      filename = filename_for_2026(recipient: recipient, type: type)
      return "#{directory}/#{filename}" if filename
    end

    "#{directory}/#{legacy_filename(type)}.pdf"
  end

  def filename_for_2026(recipient:, type:)
    case type.to_sym
    when :ambassador_appreciation
      ambassador_filename(recipient)
    when :ambassador_letter
      ambassador_letter_filename(recipient)
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

  def ambassador_letter_filename(recipient)
    if recipient.account.chapter_ambassador?
      "chapter_ambassador_letter.pdf"
    else
      "club_ambassador_letter.pdf"
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

  def legacy_filename(type)
    case type.to_sym
    when :mentor
      "mentor_appreciation"
    when :grand_prize_winner
      "grand_prize_winner"
    else
      type.to_s
    end
  end
end
