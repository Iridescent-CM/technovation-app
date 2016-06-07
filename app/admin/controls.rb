require './app/models/survey/survey.rb'

ActiveAdmin.register_page "Controls" do
  content do
    render partial: 'control'
  end

  page_action :mark_semifinalists, method: :post do
    begin
      RankingController.mark_semifinalists
    rescue ArgumentError
      redirect_to admin_controls_path, alert: "Marking did not succeed. Check that all teams have at least 1 rubric."
      return
    end
    redirect_to admin_controls_path, notice: "Advancing teams marked with is_semi_finalist tag"
  end

  page_action :mark_finalists, method: :post do
    begin
      RankingController.mark_finalists
    rescue ArgumentError
      redirect_to admin_controls_path, alert: "Marking did not succeed. Check that all teams have at least 1 rubric for the stage."
      return
    end
    redirect_to admin_controls_path, notice: "Advancing teams marked with is_finalist tag"
  end

  page_action :mark_winners, method: :post do
    begin
      RankingController.mark_winners
    rescue ArgumentError
      redirect_to admin_controls_path, alert: "Marking did not succeed. Check that all teams have at least 1 rubric for the stage."
      return
    end
    redirect_to admin_controls_path, notice: "Advancing teams marked with is_winner tag"
  end

  page_action :quarterfinals_visibility, method: :post do
    RankingController.toggle_score_visibility('quarterfinal')
    logic = Setting.scoresVisible?('quarterfinal') ? "" : ' not'
    redirect_to admin_controls_path, notice: "Quarterfinal scores now"+logic+" visible"
  end

  page_action :semifinals_visibility, method: :post do
    RankingController.toggle_score_visibility('semifinal')
    logic = Setting.scoresVisible?('semifinal') ? "" : ' not'
    redirect_to admin_controls_path, notice: "Semifinal scores now"+logic+" visible"
  end

  page_action :finals_visibility, method: :post do
    RankingController.toggle_score_visibility('final')
    logic = Setting.scoresVisible?('final') ? "" : ' not'
    redirect_to admin_controls_path, notice: "Final scores now"+logic+" visible"
  end

  page_action :assign_judges_to_regions, method: :post do
    RankingController.assign_judges_to_regions
    redirect_to admin_controls_path, notice: "Judges have been assigned to regions. Click button again to reassign."
  end

  page_action :pre_program_survey_visibility, method: :post do
    Survey.toggle_pre_program
    pre_state = Survey.showing_pre_program_link? ? 'visible' : 'not visible'
    redirect_to admin_controls_path, notice: "Pre-Program Survey is #{pre_state} for students, mentors and coaches"
  end

  page_action :post_program_survey_visibility, method: :post do
    Survey.toggle_post_program
    post_state = Survey.showing_post_program_link? ? 'visible' : 'not visible'
    redirect_to admin_controls_path, notice: "Post-Program Survey is #{post_state} for students, mentors and coaches"
  end

end
