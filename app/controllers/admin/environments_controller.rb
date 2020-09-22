module Admin
  class EnvironmentsController < AdminController

    def show
      @important_dates = ImportantDates.methods(false).collect { |method_name|
        [method_name.to_s.titleize, ImportantDates.send(method_name)]
      }.sort { |a, b|
        a[1] <=> b[1]
      }.to_h

      @enables = ENV.keys.filter { |key|
        key.upcase.starts_with? "ENABLE_"
      }.sort.collect { |key|
        [key.upcase, ENV[key]]
      }.to_h

      @mailing_list_keys = ENV.keys.filter { |key|
        key.upcase.ends_with? "_LIST_ID"
      }.sort.collect { |key|
        [key.to_s.titleize, ENV[key]]
      }.to_h
    end
  end
end
