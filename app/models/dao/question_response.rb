module Dao
  class QuestionResponse
    delegate :destroy, :find, :all, :build, :create, to: :question_responses
    attr_reader :question_responses

    def initialize exam_sitting_id, question_id
      @exam_sitting = ::ExamSitting.find exam_sitting_id
      @question_responses = @exam_sitting.question_responses
      @question = @exam_sitting.exam.questions.find question_id
    end

    def get_answers
      @question.answers
    end

    def answered? 
      @question_responses.where(question_id: @question_id).present?
    end

    def next_question
      return @exam_sitting if check_exam_is_complete!

      [@exam_sitting, @exam_sitting.next_question]
    end

    def new_question_response
      @question.question_responses.build exam_sitting: @exam_sitting
    end

    def all_question_responses
      all
    end

    def find_question_response id
      find id
    end

    def create_question_response score, guesses
      question_response = new_question_response

      if question_response.valid?
        question_response.score     = score.total
        question_response.max_score = score.max
        question_response.save

        guesses[:correct].each do |id|
          create_guess(question_response, true, id)
        end

        guesses[:incorrect].each do |id|
          create_guess(question_response, false, id)
        end

      else
        question_response.destroy
      end

      question_response
    end

    def check_exam_is_complete!
      if @exam_sitting.all_answered?
        @exam_sitting.update completed: true
      end
    end

    private

    def create_guess question_response, correct, id
      question_response.guesses.create answer_id: id, correct: correct
    end

    def create_answer id
      answer = @question.answers.find(id)
      question_response.guesses.create answer: answer, correct: answer.correct
    end
  end

end
