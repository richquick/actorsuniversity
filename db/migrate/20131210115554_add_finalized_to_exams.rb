class AddFinalizedToExams < ActiveRecord::Migration
  def change
    add_column :exams, :finalized, :boolean
  end
end
