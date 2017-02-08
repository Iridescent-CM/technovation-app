class BusinessPlan < ActiveRecord::Base
  belongs_to :team_submission, touch: true

  mount_uploader :uploaded_file, FileProcessor

  def file_url
    uploaded_file ? uploaded_file_url : remote_file_url
  end

  def remote_file_url=(url)
    sanitized_url = if url.match(%r{\Ahttps?://})
            url
          else
            url.sub(%r{\A(?:\w+://)?}, "http://")
          end

    super(sanitized_url)
  end
end
