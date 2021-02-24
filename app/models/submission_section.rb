class SubmissionSection
  SECTION_NAMES = {
    0 => "start",
    1 => "ideation",
    2 => "pitch",
    3 => "code",
    4 => "business",
    5 => "pitch_presentation"
  }

  SECTION_GROUPS = {
    0 => %w[honor_code team_photo],
    1 => %w[app_name app_description app_details],
    2 => %w[demo_video_link pitch_video_link screenshots],
    3 => %w[development_platform source_code source_code_url],
    4 => %w[business_plan],
    5 => %w[pitch_presentation]
  }

  attr_reader :piece, :controller

  def initialize(piece, controller = nil)
    @piece = piece
    @controller = controller
    freeze
  end

  def to_s
    if name_idx = SECTION_GROUPS.keys.detect { |k|
      SECTION_GROUPS[k].include?(piece)
    }
      SECTION_NAMES[name_idx]
    elsif !!controller
      controller.get_cookie(CookieNames::LAST_VISITED_SUBMISSION_SECTION) ||
        SECTION_NAMES[1]
    else
      SECTION_NAMES[1]
    end
  end
end
