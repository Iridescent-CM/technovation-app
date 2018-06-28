class DataAnalysisSerializer
  include FastJsonapi::ObjectSerializer
  attributes :labels, :data, :urls
end
