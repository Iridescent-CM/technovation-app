module TeamsHelper

  def show_all_errors(errors)
      errors.map {|field| "<strong>"+ field + "</strong>" }.to_sentence(last_word_connector: ' and ')
  end
end
