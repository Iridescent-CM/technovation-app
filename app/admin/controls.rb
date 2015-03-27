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
	  redirect_to admin_controls_path, notice: "Advancing teams marked with issemifinalist tag"
	end

	page_action :mark_finalists, method: :post do
	  RankingController.mark_finalists
	  redirect_to admin_controls_path, notice: "Advancing teams marked with isfinalist tag"
	end

	page_action :mark_winners, method: :post do
	  RankingController.mark_winners
	  redirect_to admin_controls_path, notice: "Winning teams marked with iswinner tag"
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


	# def self.set_score_visibility(stage)
	#   RankingController.toggle_score_visibility(stage)
	#   logic = Setting.scoresVisible?(stage) ? "" : ' not'
	#   redirect_to admin_controls_path, notice: stage+" scores now"+logic+" visible"
	# end

end