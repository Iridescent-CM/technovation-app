class DataAnalysisSerializer
  include FastJsonapi::ObjectSerializer
  attributes :totals, :labels, :data, :datasets, :urls
end
