# frozen_string_literal: true

class Project < ApplicationRecord
  has_one_attached :avatar

  has_many :documents, dependent: :destroy
  has_many :teams
  has_many :users, through: :teams

  def contract_party_users
    users.where(teams: { role: Team.roles[:contract_party] })
  end

  def signatory_party_users
    users.where(teams: { role: Team.roles[:signatory_party] })
  end
end
