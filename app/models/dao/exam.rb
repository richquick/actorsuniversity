module Dao
  class Exam
    def create_exam attributes
      ::Exam.create attributes
    end

    def update_exam id, attributes
      ::Exam.find(id).
        tap{|e|e.update_attributes attributes}
    end

    def add_question exam_id, attributes
      exam = ::Exam.find(exam_id)

      exam.questions.create attributes
    end

    def update_question question_id, attributes
      question = ::Question.find(question_id)

      question.update attributes
      question
    end
  end
end
