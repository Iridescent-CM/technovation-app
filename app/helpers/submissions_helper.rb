module SubmissionsHelper
  def submission_progress_bar(submission)
    content_tag :div, class: "bar-graph" do
      html = content_tag :div, class: "bar-wrap" do
        content_tag(:span, nil, class: "bar-fill",
          style: "width: #{submission.percent_complete}%;")
      end

      html += content_tag(:p, class: "scent scent--soft") do
        "#{submission.percent_complete}% completed"
      end
    end
  end
end
