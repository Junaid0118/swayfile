class Contract < ApplicationRecord
  belongs_to :project
  belongs_to :folder, optional: true
  has_many :documents
end
