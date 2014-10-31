module Dao
  class ExamSitting
    def unanswered_questions exam_sitting
      exam_sitting.unanswered_questions
    end

    def first_unanswered_question exam_sitting
      exam_sitting.first_unanswered_question
    end

    def create_exam_sitting attributes
      ::ExamSitting.create attributes
    end

    def new_exam_sitting exam_id
      ::ExamSitting.new exam_id: exam_id
    end

    def all_exam_sitting
      ::ExamSitting.all
    end

    def find_exam_sitting id
      ::ExamSitting.find id
    end

    def update_exam_sitting id, attributes
      find(id).tap do |g|
        g.update_attributes attributes
      end
    end

    def destroy_exam_sitting id
      ::ExamSitting.destroy(id)
    end

    def first_question_for exam_sitting
      exam_sitting.exam.questions.first
    end
  end
end
