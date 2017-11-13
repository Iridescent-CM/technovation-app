module DivisionChooser
  def reconsider_division
    self.division_id = Division.for(self).id

    if respond_to?(:submission) and
        (saved_change_to_division_id? or
          division_id_changed?)
      submission.touch
    end
  end

  def reconsider_division_with_save
    reconsider_division
    save
  end
end
