require "rails_helper"
require "./lib/certificate_field_mapping"

RSpec.describe "Certificate layout field mapping" do
  it "maps every extracted layout field to recipient, description, or division values" do
    unmapped = []

    Dir.glob(Rails.root.join("config/certificate_layouts/*/*.yml")).sort.each do |path|
      layout = YAML.load_file(path)

      layout.fetch("fields").each_key do |field_name|
        value_key = CertificateFieldMapping.value_key(field_name)

        unless %i[recipient_name full_text division team_name app_name region].include?(value_key)
          unmapped << "#{path.sub(Rails.root.to_s + '/', '')}: #{field_name} -> #{value_key}"
        end
      end
    end

    expect(unmapped).to be_empty, "Unmapped layout fields:\n#{unmapped.join("\n")}"
  end
end
