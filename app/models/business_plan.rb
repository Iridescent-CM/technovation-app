class BusinessPlan < ActiveRecord::Base
  mount_uploader :uploaded_file, FileProcessor
end

# LEGACY MODEL FOR 2017 DATA
# DO NOT USE
