class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :nullify
  has_many :folders, dependent: :destroy

  has_many :documents, dependent: :destroy
  has_many :teams
  has_many :projects, through: :teams

  has_many :clauses, dependent: :destroy


  def name
    "#{first_name} #{last_name}"
  end
end
