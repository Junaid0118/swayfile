class ClausePolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def create?
    team = record.project.teams.find_by(user_id: user.id)
    team.user_role == "Admin"
  end
end
