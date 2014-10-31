class AddArchivedToLessons < ActiveRecord::Migration
  def change
    add_column :lessons, :archived, :boolean
  end
end
