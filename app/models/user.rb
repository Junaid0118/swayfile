class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  has_one_attached :avatar
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :comments, dependent: :nullify
  has_many :folders, dependent: :destroy

  has_many :documents, dependent: :destroy
  has_many :teams
  has_many :projects, through: :teams

  has_many :clauses, dependent: :destroy
  has_many :clause_histories, dependent: :destroy

  has_many :folder_invitees
  has_many :invitees_folders, through: :folder_invitees, source: :folder
  

  def name
    "#{first_name} #{last_name}"
  end

  def generate_full_address
    full_address = "#{address_line_1},\n"
    full_address += "#{address_line_2},\n" unless address_line_2.blank?
    full_address += "#{town} #{postal_code} #{state}\n"
    full_address += "#{country}"
    full_address
  end
end
