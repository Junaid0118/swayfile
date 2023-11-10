# frozen_string_literal: true

class Project < ApplicationRecord
  has_one_attached :avatar

  belongs_to :folder, optional: true
  belongs_to :created_by, class_name: 'User', optional: true

  validates :name, uniqueness: true

  has_many :comments, dependent: :destroy
  has_many :documents, dependent: :destroy
  has_many :teams
  has_many :users, through: :teams
  has_many :clauses, dependent: :destroy

  def time_difference_in_words
    from_time = created_at
    to_time = Time.now
    distance_in_seconds = (from_time - to_time).to_i.abs
  
    case
    when distance_in_seconds < 1.minute
      "just now"
    when distance_in_seconds < 1.hour
      "#{distance_in_seconds / 1.minute} minutes ago"
    when distance_in_seconds < 1.day
      "#{distance_in_seconds / 1.hour} hours ago"
    else
      "#{distance_in_seconds / 1.day} days ago"
    end
  end

  def contract_party_users
    users.where(teams: { role: Team.roles[:contract_party] })
  end

  def signatory_party_users
    users.where(teams: { role: Team.roles[:signatory_party] })
  end
end
