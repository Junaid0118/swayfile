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
    user == record.created_by || user.in?(record.signatory_party_users) || user.in?(record.contract_party_users)
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

  def update?
    user == record.created_by
  end
end