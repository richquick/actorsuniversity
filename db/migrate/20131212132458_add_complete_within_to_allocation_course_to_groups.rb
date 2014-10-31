class AddCompleteWithinToAllocationCourseToGroups < ActiveRecord::Migration
  def change
    add_column :allocation_course_to_groups, :complete_within, :integer
  end
end
