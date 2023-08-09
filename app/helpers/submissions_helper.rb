module SubmissionsHelper
  def submission_progress_bar(submission)
    title = "Missing Submisison Pieces: #{format_missing_submission_pieces(submission)}" if submission.missing_pieces.present?

    content_tag :div, class: "bar-graph" do
      html = content_tag :div, class: "bar-wrap", title: title do
        content_tag(:span, nil,
          class: "bar-fill",
          style: "width: #{submission.percent_complete}%;")
      end

      html + content_tag(:p, class: "scent scent--soft", title: title) do
        "#{submission.percent_complete}% completed"
      end
    end
  end

  def link_to_submission_source_code(submission)
    if submission.developed_on?("Thunkable")
      text = "Open this project in Thunkable"
      url = submission.thunkable_project_url
    else
      text = "Download the technical work"
      url = submission.source_code_url
    end

    link_to(
      web_icon(
        "code",
        remote: true,
        size: 12,
        color: "5ABF94",
        text: text,
      ),
      url,
      target: :_blank,
    )
  end

  def format_missing_submission_pieces(submission)
    pieces = submission.missing_pieces.map(&:humanize).map(&:titlecase).join(", ")
    pieces = pieces.gsub("App Name", "Project Name")
    pieces = pieces.gsub("App Description", "Project Description")
    pieces
  end

  def additional_question_labels(team_submission)
    case team_submission.seasons.last
    when 2021
      [:ai, :climate_change, :game]
    when 2022
      [:ai, :climate_change, :solves_health_problem]
    when 2023
      [:ai, :climate_change, :solves_hunger_or_food_waste, :uses_open_ai]
    when 2024
      [:ai, :climate_change, :solves_hunger_or_food_waste, :uses_open_ai]
    end
  end
end
