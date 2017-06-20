module DivisionChooser
  def reconsider_division
    self.division_id = Division.for(self).id
    if submission.present? and saved_change_to_division_id?
      submission.touch
    end
  end

  def reconsider_division_with_save
    reconsider_division
    save
  end
end
