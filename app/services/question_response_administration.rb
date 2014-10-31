class QuestionResponseAdministration
  include Hexagonal

  def all
    dao.all_question_responses
  end

  def answered?
    dao.answered?
  end

  def new_question_response
    dao.new_question_response
  end

  def answer_question guess_ids
    answers = dao.get_answers
    score, guesses = QuestionScoreCalculator.calculate_score guess_ids, answers
    question_response = dao.create_question_response(score, guesses)

    if question_response.valid?(:answered)
      exam_sitting, next_question = dao.next_question

      if next_question
        framework.success_next_question exam_sitting, next_question
      else
        framework.success_exam_complete exam_sitting
      end
    else
      question_response.destroy #Was persisted to allow saving associations
      framework.create_failure question_response
    end
  end

  def edit id
    dao.find_question_response id
  end

  def destroy id
    dao.destroy_question_response id
  end

  def update id, attributes
    question_response = dao.update_question_response id, attributes

    meth = question_response.valid? ? :update_success : :update_failure
    framework.send meth, question_response
  end
end
