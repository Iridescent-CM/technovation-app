module LabelForStatedGoal
  def self.call(goal)
    case goal
    when "Poverty"
      "Poverty Examples include: eradicating extreme poverty (measured as living under $1.25 a day), implementing social protection systems for all, and ensuring that all men and women have equal access to economic resources."

    when "Environment"
      "Environment examples include: improving education and awareness about climate change and strengthening resilience to climate-change hazards in all countries."

    when "Peace"
      "Peace examples include: significantly reducing violence, ending abuse of children, reducing corruption and bribery, ensuring equal access to justice for all, and ensuring public access to information."

    when "Equality"
      "Equality examples include: ending all form of discrimination against girls and women everywhere and ensuring women’s full and effective participation and equal opportunities for leadership."

    when "Education"
      "TODO: Education label"

    when "Health"
      "TODO: Health label"

    when "No goal selected!"
      "The team did not select a sustainable development goal. Score should be 0 – Incomplete."
    end
  end
end
