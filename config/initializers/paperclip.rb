Paperclip::Attachment.default_options[:url] = ':s3_domain_url'
if Rails.env.production?
  Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
elsif Rails.env.test?
  Paperclip::Attachment.default_options[:path] = "./public/#{Rails.env}/:class/:attachment/:id_partition/:style/:filename"
else
  Paperclip::Attachment.default_options[:path] = "/#{Rails.env}/:class/:attachment/:id_partition/:style/:filename"
end
