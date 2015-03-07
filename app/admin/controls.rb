ActiveAdmin.register_page "Controls" do
  content do
  	render partial: 'control'
  end


  #http://stackoverflow.com/questions/10193334/active-admin-and-custom-method
  #http://activeadmin.info/docs/10-custom-pages.html
	page_action :mark_semifinalists, method: :post do
	  # ...
	  RankingController.mark_semifinalists
	  redirect_to admin_controls_path, notice: "Advancing teams marked with issemifinalist tag"
	end

	page_action :mark_finalists, method: :post do
	  # ...
	  RankingController.mark_finalists
	  redirect_to admin_controls_path, notice: "Advancing teams marked with isfinalist tag"
	end

	page_action :mark_winners, method: :post do
	  # ...
	  RankingController.mark_winners
	  redirect_to admin_controls_path, notice: "Winning teams marked with iswinner tag"
	end

	page_action :quarterfinals_visibility, method: :post do
	end

	page_action :semifinals_visibility, method: :post do
	end

	page_action :finals_visibility, method: :post do
	end

end