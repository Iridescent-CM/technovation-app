module AccountFormHelpers
  def select_gender(which_one)
    if which_one.to_sym == :random
      Account.genders.keys.shuffle.each do |gender|
        select gender, from: "Gender identity"
      end

      # looping through each one implicitly tests that
      # they are all there in the HTML
    else
      select which_one, from: "Gender identity"
    end
  end
end
