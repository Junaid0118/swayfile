# frozen_string_literal: true

class Project < ApplicationRecord
  before_create :set_status_false

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

  def members(user_role)
    users.where(teams: { user_role: user_role })
  end


  def signatory_party_users
    users.where(teams: { role: Team.roles[:signatory_party] })
  end

  def owners
    owner_ids = users.where(teams: { user_role: "Owner" }).pluck(:id)
    User.where(id: owner_ids + [self.created_by_id])
  end
  

  def approval_ratio
    teams.where(user_role: "Owner").size + 1
  end

  private

  def set_status_false
    self.status = "false"
  end
end
