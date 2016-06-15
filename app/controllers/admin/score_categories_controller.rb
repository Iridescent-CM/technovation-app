module Admin
  class ScoreCategoriesController < AdminController
    def index
      @score_categories = ScoreCategory.all
    end

    def new
      @score_category = ScoreCategory.new
    end

    def create
      @score_category = ScoreCategory.new(score_category_params)

      if @score_category.save
        redirect_to admin_score_categories_path,
          success: t('controllers.admin.score_categories.create.success')
      else
        render :new
      end
    end

    def edit
      score_category
      render :new
    end

    def update
      if score_category.update_attributes(score_category_params)
        redirect_to admin_score_categories_path,
          success: t('controllers.admin.score_categories.update.success')
      else
        render :new
      end
    end

    private
    def score_category
      @score_category ||= ScoreCategory.find(params.fetch(:id))
    end

    def score_category_params
      params.require(:score_category).permit(
        :name,
        score_questions_attributes: [
          :_destroy,
          :id,
          :label,
          score_values_attributes: [
            :_destroy,
            :id,
            :label,
            :value
          ]
        ]
      )
    end
  end
end
