require "rails_helper"

describe VideoUrl do
  let(:video_url) { VideoUrl.new(url) }
  let(:url) { "" }

  describe "#root" do
    context "YouTube" do
      let(:url) { "https://www.youtube.com/watch?v=UjDGTADz9Do" }

      it "returns a root URL for YouTube" do
        expect(video_url.root).to eq("https://www.youtube.com/embed/")
      end
    end

    context "Vimeo" do
      let(:url) { "https://vimeo.com/96816279" }

      it "returns a root URL for Vimeo" do
        expect(video_url.root).to eq("https://player.vimeo.com/video/")
      end
    end

    context "Youku" do
      let(:url) { "https://v.youku.com/v_show/id_XMTA1Mjk5OTQ4.html?extra-stuff" }

      it "returns a root URL for Youku" do
        expect(video_url.root).to eq("https://player.youku.com/embed/")
      end
    end

    context "when it's not a YouTube, Vimeo, or Youku video" do
      let(:url) { "http://duckduckgo.com/not-a-video" }

      it "returns nil" do
        expect(video_url.root).to eq(nil)
      end
    end
  end

  describe "#video_id" do
    context "YouTube" do
      let(:url) { "https://www.youtube.com/watch?v=UjDGTADz9Do?extra-stuff" }

      it "extracts and returns the video id" do
        expect(video_url.video_id).to eq("UjDGTADz9Do")
      end

      context "shortened YouTube url" do
        let(:url) { "https://youtu.be/UjDGTADz9Do" }

        it "extracts and returns the video id" do
          expect(video_url.video_id).to eq("UjDGTADz9Do")
        end
      end
    end

    context "Vimeo" do
      let(:url) { "https://vimeo.com/96816279" }

      it "extracts and returns the video id" do
        expect(video_url.video_id).to eq("96816279")
      end
    end

    context "Youku" do
      let(:url) { "https://v.youku.com/v_show/id_XMTA1Mjk5OTQ4.html?extra-stuff" }

      it "extracts and returns the video id" do
        expect(video_url.video_id).to eq("XMTA1Mjk5OTQ4")
      end

      context "Youku variant" do
        let(:url) { "https://v.youku.com/v_show/id_XMTA1Mjk5OTQ4==.html?extra-stuff" }

        it "extracts and returns the video id" do
          expect(video_url.video_id).to eq("XMTA1Mjk5OTQ4")
        end
      end
    end

    context "when it's not a YouTube, Vimeo, or Youku video" do
      let(:url) { "http://duckduckgo.com/not-a-video" }

      it "returns an empty string" do
        expect(video_url.video_id).to eq("")
      end
    end
  end

  describe "#valid?" do
    context "when the video is valid" do
      before do
        allow(video_url).to receive(:video_id).and_return("some-video-id")
        allow(video_url).to receive(:root).and_return("a-url-root")
      end

      it "returns true" do
        expect(video_url.valid?).to eq(true)
      end
    end

    context "when the video is not valid" do
      before do
        allow(video_url).to receive(:video_id).and_return(false)
        allow(video_url).to receive(:root).and_return(false)
      end

      it "returns true" do
        expect(video_url.valid?).to eq(false)
      end
    end
  end
end
