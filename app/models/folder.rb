class Folder < ApplicationRecord
    belongs_to :parent_folder, class_name: "Folder", optional: true
    has_many :subfolders, class_name: "Folder", foreign_key: "parent_folder_id"

    belongs_to :user
    has_many :projects

    before_save :generate_slug

    def full_path
        if parent_folder_id.nil?
          name
        else
          parent_folder.full_path + " <i class='ki-outline ki-right fs-2x text-primary mx-1'></i> " + name
        end
      end

    private

    def generate_slug
       self.slug = name.parameterize
    end

    def parent_folder
        Folder.find_by(id: parent_folder_id)
    end
end
