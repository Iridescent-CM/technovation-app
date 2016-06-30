require "rails_helper"

class ScoreSubmissionTest < Capybara::Rails::TestCase
  def setup
    create_test_scoring_environment

    judge = CreateAccount.(judge_attributes({
      judge_profile_attributes: { scoring_expertise_ids: ScoreCategory.is_expertise.pluck(:id) }
    }))

    sign_in(judge)
    visit judge_scores_path
    click_link 'Judge submissions'

    within('.ideation') { choose 'No' }
    within('.technology') { choose 'Yes' }

    click_button 'Save'
  end

  def test_judge_sees_non_expertise_categories
    click_link 'Edit'
    assert page.has_content?("Bonus")
  end

  def test_score_submission
    assert_equal 1, submission.scores.count
    assert_equal 7, submission.scores.last.total
  end

  def test_score_only_once
    refute page.has_link?('Judge submissions')
    assert page.has_content?(
      "There are no more submissions for you to judge. Thank you for your feedback!"
    )
  end

  def test_edit_score
    click_link 'Edit'
    within('.ideation') { choose 'Yes' }
    within('.technology') { choose 'No' }
    click_button 'Save'

    assert_equal 1, submission.scores.count
    assert_equal 3, submission.scores.last.total
  end

  def test_add_comments
    click_link 'Edit'

    within('.ideation') do
      fill_in 'Comment', with: 'You did it!'
    end

    within('.technology') do
      fill_in 'Comment', with: 'You did not do it...'
    end

    click_button 'Save'

    click_link 'Edit'

    within('.ideation') do
      assert page.has_css?('textarea', text: 'You did it!')
    end

    within('.technology') do
      assert page.has_css?('textarea', text: 'You did not do it...')
    end
  end
end
