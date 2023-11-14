# frozen_string_literal: true

class Folder < ApplicationRecord
  belongs_to :parent_folder, class_name: 'Folder', optional: true
  has_many :subfolders, class_name: 'Folder', foreign_key: 'parent_folder_id', dependent: :destroy

  belongs_to :user
  has_many :projects, dependent: :nullify

  has_many :folder_invitees
  has_many :invitees, through: :folder_invitees, class_name: 'User', source: :user


  before_save :generate_slug

  def full_path_array
    if parent_folder_id.nil?
      [name]
    else
      parent_folder.full_path_array + [name]
    end
  end
  
  def full_path_string(separator = ', ')
    full_path_array.join(separator)
  end  
  

  private

  def generate_slug
    self.slug = name.parameterize
  end

  def parent_folder
    Folder.find_by(id: parent_folder_id)
  end
end
