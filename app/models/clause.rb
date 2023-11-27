class Clause < ApplicationRecord
    belongs_to :project
    belongs_to :user

    has_many :suggests, dependent: :destroy
    has_many :clause_histories, dependent: :destroy

    def approvers
        User.where(id: approved_by).pluck(:name)
    end
end
