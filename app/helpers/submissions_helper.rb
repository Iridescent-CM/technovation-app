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
      text = "Download the source code"
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

  def label_for_submission_plan(submission)    
    if submission.senior_division?
      :business_plan
    elsif submission.junior_division?
      :user_adoption_plan
    end
  end

  def format_missing_submission_pieces(submission)
    pieces = submission.missing_pieces.map(&:humanize).map(&:titlecase).join(", ")
    pieces = pieces.gsub("App Name", "Project Name")
    pieces = pieces.gsub("App Description", "Project Description")
    pieces
  end
end
