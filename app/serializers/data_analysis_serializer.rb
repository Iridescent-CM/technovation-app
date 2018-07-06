class DataAnalysisSerializer
  include FastJsonapi::ObjectSerializer
  attributes :totals, :labels, :data, :urls
end
