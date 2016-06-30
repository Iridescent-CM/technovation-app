if Rails.env.development?
  ActiveRecordQueryTrace.enabled = ENV.fetch("ACTIVE_RECORD_QUERY_TRACE") { false }
end
