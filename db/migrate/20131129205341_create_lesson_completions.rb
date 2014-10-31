class CreateLessonCompletions < ActiveRecord::Migration
  def change
    create_table :lesson_completions do |t|
      t.integer :user_id
      t.integer :lesson_id

      t.timestamps
    end
  end
end
