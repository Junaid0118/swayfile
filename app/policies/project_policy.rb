class ProjectPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where('created_by_id = ? OR id IN (?) OR id IN (?)',
                  user.id,
                  user.signatory_party_users.pluck(:id),
                  user.contract_party_users.pluck(:id))
    end
  end

  def show?
    team = record.teams.find_by(user_id: user.id)
    user == record.created_by || team.user_role == "Owner" 
  end

  def review?
    true
  end

  def close_contract?
    user == record.created_by
  end

  def signatories?
    user == record.created_by || user.in?(record.signatory_party_users) || user.in?(record.contract_party_users)
  end

  def discussions?
    user == record.created_by || user.in?(record.signatory_party_users) || user.in?(record.contract_party_users)
  end

  def team?
    user == record.created_by || user.in?(record.signatory_party_users) || user.in?(record.contract_party_users)
  end

  def contract?
    user == record.created_by || user.in?(record.signatory_party_users) || user.in?(record.contract_party_users)
  end

  def edit?
    user == record.created_by
  end

  def details?
    user == record.created_by || user.in?(record.signatory_party_users) || user.in?(record.contract_party_users)
  end

  def add_member_to_project?
    true
  end

  def add_signatory_to_project?
    true
  end

  def update_role?
    true
  end

  def remove_member_from_team?
    true
  end


  def move_to_folder?
    true
  end

  def update?
    true
  end

  def update_party?
    true
  end

  def index?
    team = record.teams.find_by(user_id: user.id)
    user == record.created_by || team.user_role == "Owner" || team.user_role == "Can Edit"
  end
end
