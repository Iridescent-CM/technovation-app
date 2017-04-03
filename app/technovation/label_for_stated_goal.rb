module LabelForStatedGoal
  def self.call(goal)
    case goal
    when "Poverty"
      "This team chose Poverty as their sustainable development goal. Examples include: eradicating extreme poverty (measured as living under $1.25 a day), implementing social protection systems for all, and ensuring that all men and women have equal access to economic resources."

    when "Environment"
      "This team chose Environment as their sustainable development goal. Examples include: improving education and awareness about climate change and strengthening resilience to climate-change hazards in all countries."

    when "Peace"
      "This team chose Peace as their sustainable development goal. Examples include: significantly reducing violence, ending abuse of children, reducing corruption and bribery, ensuring equal access to justice for all, and ensuring public access to information."

    when "Equality"
      "This team chose Equality as their sustainable development goal. Examples include: ending all form of discrimination against girls and women everywhere and ensuring women’s full and effective participation and equal opportunities for leadership."

    when "Education"
      "This team chose Education as their sustainable development goal. Examples include: ensuring quality education for all, creating lifelong learning opportunities, increasing primary and secondary school completion rates."

    when "Health"
      "This team chose Health as their sustainable development goal. Examples include: promoting well-being at all ages, reducing health risks, improving healthcare for women, reducing cases of diseases, addressing substance abuse."

    when "No goal selected!"
      "The team did not select a sustainable development goal. Score should be 0 – Incomplete."
    end
  end
end
