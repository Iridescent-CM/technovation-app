require "rails_helper"

RSpec.describe FilestackHelper, type: :helper do
  describe "#filestack_js_deferred_init_tag" do
    subject(:tag) { filestack_js_deferred_init_tag }

    it "returns a script tag" do
      expect(tag).to start_with("<script>")
      expect(tag).to end_with("</script>")
    end

    it "does not reference filestack.init at parse time" do
      expect(tag).to include('typeof filestack !== "undefined"')
      expect(tag).to include("function initFilestack()")
      expect(tag).not_to match(/\A<script>\s*var filestack_client = filestack\.init/m)
    end

    it "assigns the configured client name after load" do
      client_name = Rails.application.config.filestack_rails.client_name

      expect(tag).to include("window.#{client_name} = filestack.init")
      expect(tag).to include('addEventListener("load", initFilestack)')
    end
  end
end
