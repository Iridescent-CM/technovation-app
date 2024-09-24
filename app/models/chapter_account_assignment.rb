class ChapterAccountAssignment < ApplicationRecord
  belongs_to :chapter
  belongs_to :account
  belongs_to :profile, polymorphic: true
end
