class ChapterAmbassadorSerializer
  include FastJsonapi::ObjectSerializer
  set_key_transform :camel_lower

  set_id :random_id

  attributes :name, :program_name

  attribute(:api_root) do |account|
    "#{account.scope_name}"
  end

  attribute(:avatar_url) do |account|
    account.profile_image.thumb.url
  end

  attribute(:has_provided_intro, &:provided_intro?)
end
