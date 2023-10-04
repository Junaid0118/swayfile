class Folder < ApplicationRecord
    belongs_to :parent_folder, class_name: "Folder", optional: true
    has_many :subfolders, class_name: "Folder", foreign_key: "parent_folder_id"

    has_many :projects

    before_save :generate_slug

    private

    def generate_slug
       self.slug = name.parameterize
    end
end
