# frozen_string_literal: true

class Project < ApplicationRecord
  has_one_attached :avatar

  belongs_to :folder, optional: true

  has_many :documents, dependent: :destroy
  has_many :teams
  has_many :users, through: :teams

  belongs_to :creator, class_name: 'User', foreign_key: 'creator_id'

  def contract_party_users
    users.where(teams: { role: Team.roles[:contract_party] })
  end

  def signatory_party_users
    users.where(teams: { role: Team.roles[:signatory_party] })
  end
end
