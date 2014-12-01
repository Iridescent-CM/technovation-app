class TeamRequest < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  validates_uniqueness_of :team_id, scope: :user_id
  scope :pending, -> { where approved: false }
  scope :approved, -> { where approved: true }

  after_save :update_team_division, :if => :changed_approval?
  after_destroy :update_team_division, :if => :approved?
  after_destroy :destroy_empty_teams, :if => :approved?


  def update_team_division
    team.update_division!
  end

  def destroy_empty_teams
    team.check_empty!
  end

  def changed_approval?
    # new or the approval changed?
    id_changed? or approved_changed?
  end

  def approved?
    self.approved
  end



end
