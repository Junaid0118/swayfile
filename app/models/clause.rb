class Clause < ApplicationRecord
    belongs_to :project
    belongs_to :user

    has_many :suggests
end
