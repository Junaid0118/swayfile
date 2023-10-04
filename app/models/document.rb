class Document < ApplicationRecord
  belongs_to :contract
  belongs_to :folder, optional: true
end
