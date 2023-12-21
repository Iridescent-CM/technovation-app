PDFKit.configure do |config|
  path = ENV.fetch("WKHTMLTOPDF_PATH", nil)
  config.wkhtmltopdf = path if path.present?
end
