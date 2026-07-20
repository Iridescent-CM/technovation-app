require "rails_helper"
require "./lib/certificate_template_paths"

RSpec.describe CertificateTemplatePaths do
  let(:account) { instance_double(Account, chapter_ambassador?: false) }
  let(:team) { instance_double(Team, division_name: "junior", present?: true) }
  let(:recipient) do
    instance_double(
      CertificateRecipient,
      account: account,
      team: team
    )
  end

  describe ".for" do
    context "when the season is before 2026" do
      it "uses the legacy filename pattern" do
        path = described_class.for(recipient: recipient, type: :participation, season: 2025)

        expect(path).to eq("./lib/certs/2025/participation.pdf")
      end

      it "uses the legacy mentor template name" do
        path = described_class.for(recipient: recipient, type: :mentor, season: 2025)

        expect(path).to eq("./lib/certs/2025/mentor_appreciation.pdf")
      end
    end

    context "when the season is 2026" do
      it "resolves standard certificate filenames" do
        path = described_class.for(
          recipient: recipient,
          type: :semifinalist,
          season: 2026
        )

        expect(path).to eq("./lib/certs/2026/semifinalist.pdf")
      end

      it "resolves the mentor template" do
        path = described_class.for(
          recipient: recipient,
          type: :mentor,
          season: 2026
        )

        expect(path).to eq("./lib/certs/2026/mentor.pdf")
      end

      it "resolves the quarterfinalist template" do
        path = described_class.for(
          recipient: recipient,
          type: :quarterfinalist,
          season: 2026
        )

        expect(path).to eq("./lib/certs/2026/quaterfinalist.pdf")
      end

      it "resolves chapter ambassador templates" do
        path = described_class.for(
          recipient: instance_double(
            CertificateRecipient,
            account: instance_double(Account, chapter_ambassador?: true),
            team: team
          ),
          type: :ambassador_appreciation,
          season: 2026
        )

        expect(path).to eq("./lib/certs/2026/chapter_ambassador.pdf")
      end

      it "resolves club ambassador templates" do
        path = described_class.for(
          recipient: recipient,
          type: :ambassador_appreciation,
          season: 2026
        )

        expect(path).to eq("./lib/certs/2026/club_ambassador.pdf")
      end

      it "resolves the finalist template" do
        path = described_class.for(
          recipient: recipient,
          type: :finalist,
          season: 2026
        )

        expect(path).to eq("./lib/certs/2026/finalist.pdf")
      end

      it "resolves division-specific grand prize templates" do
        path = described_class.for(
          recipient: recipient,
          type: :grand_prize_winner,
          season: 2026
        )

        expect(path).to eq("./lib/certs/2026/grand_prize_junior.pdf")
      end

      it "resolves manual prize templates" do
        path = described_class.for(
          recipient: recipient,
          type: :climate_prize,
          season: 2026
        )

        expect(path).to eq("./lib/certs/2026/climate_prize.pdf")
      end

      it "resolves chapter ambassador letter templates" do
        path = described_class.for(
          recipient: instance_double(
            CertificateRecipient,
            account: instance_double(Account, chapter_ambassador?: true),
            team: team
          ),
          type: :ambassador_letter,
          season: 2026
        )

        expect(path).to eq("./lib/certs/2026/chapter_ambassador_letter.pdf")
      end

      it "resolves club ambassador letter templates" do
        path = described_class.for(
          recipient: recipient,
          type: :ambassador_letter,
          season: 2026
        )

        expect(path).to eq("./lib/certs/2026/club_ambassador_letter.pdf")
      end
    end
  end
end
