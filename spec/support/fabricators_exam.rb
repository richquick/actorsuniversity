Fabricator :exam do
  title "Final accountancy exam"
  description "You'll be qualified after this"
end

Fabricator :exam_with_questions, from: :exam do
  after_create do |e|
    e.questions << Fabricate(:question_1)
    e.questions << Fabricate(:question_2)
  end
end

Fabricator :exam_sitting do
  user { Fabricate :user }
  exam { Fabricate :exam_with_questions }
end

Fabricator :exam_sitting_with_answers, from: :exam_sitting do
  after_create do |e|
    e.questions.each do |q|
      e.question_responses.create question: q do |r|
        r.guesses.create q.answers.first
      end
    end
  end
end

Fabricator :question do
  question_text "Is this really a question?"
end

Fabricator :question_1, from: :question do
  question_text "Yes or no?"
  tag_line "Answer carefully"

  before_create do |q|
    q.answers << Fabricate(:question_1_answer_1)
    q.answers << Fabricate(:question_1_answer_2)
    q.answers << Fabricate(:question_1_answer_3)
  end
end

Fabricator :question_2, from: :question do
  question_text "What's the capital of England?"
  tag_line "In the UK"

  before_create do |q|
    q.answers << Fabricate(:question_2_answer_1)
    q.answers << Fabricate(:question_2_answer_2)
    q.answers << Fabricate(:question_2_answer_3)
  end
end

Fabricator :answer do
  text "Answer goes here"
  correct true
end

Fabricator :question_1_answer_1, from: :answer do
  text "Yes"
  correct true
end

Fabricator :question_1_answer_2, from: :answer do
  text "No"
  correct false
end

Fabricator :question_1_answer_3, from: :answer do
  text "Maybe"
  correct false
end

Fabricator :question_2_answer_1, from: :answer do
  text "London"
  correct true
end

Fabricator :question_2_answer_2, from: :answer do
  text "Paris"
  correct false
end

Fabricator :question_2_answer_3, from: :answer do
  text "Berlin"
  correct false
end


