class ClauseHistory < ApplicationRecord
  belongs_to :clause
  belongs_to :user
end
