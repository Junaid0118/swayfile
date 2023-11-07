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
    user == record.created_by || team.user_role == "Admin"
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

  def remove_member_from_team?
    user == record.created_by || user.in?(record.signatory_party_users) || user.in?(record.contract_party_users)
  end


  def move_to_folder?
    user == record.created_by || user.in?(record.signatory_party_users) || user.in?(record.contract_party_users)
  end

  def update?
    user == record.created_by
  end

  def index?
    team = record.teams.find_by(user_id: user.id)
    user == record.created_by || team.user_role == "Admin" || team.user_role == "Guest"
  end
end
