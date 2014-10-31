class AddCompleteByDateToAllocationCourseToGroups < ActiveRecord::Migration
  def change
    add_column :allocation_course_to_groups, :complete_by_date, :datetime

    add_index :allocation_course_to_groups, :complete_by_date
  end
end
