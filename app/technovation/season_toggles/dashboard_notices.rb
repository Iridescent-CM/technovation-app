class SeasonToggles
  module DashboardNotices
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      %w{mentor student judge}.each do |scope|
        define_method("#{scope}_dashboard_text=") do |text|
          store.set("#{scope}_dashboard_text", text)
        end
      end

      def set_dashboard_text(scope, txt)
        send("#{scope}_dashboard_text=", txt)
      end

      def dashboard_text(scope)
        store.get("#{scope}_dashboard_text")
      end
    end
  end
end
