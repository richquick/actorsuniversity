class LessonCompletion < ActiveRecord::Base
  belongs_to :lesson
  belongs_to :user

   comma do
     lesson :created_at
     lesson :title
     user :name
   end
end
