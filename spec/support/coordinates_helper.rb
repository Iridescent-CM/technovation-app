module CoordinatesHelper
  def stub_coordinates(coords)
    allow(CookiedCoordinates).to receive(:get).and_return(coords)
  end
end
