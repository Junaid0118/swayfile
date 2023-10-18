class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :folders, dependent: :destroy

  has_many :documents, dependent: :destroy
  has_many :teams
  has_many :projects, through: :teams


  def name
    "#{first_name} #{last_name}"
  end
end
