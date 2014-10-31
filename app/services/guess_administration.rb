class GuessAdministration
  include Hexagonal

  def all
    dao.all_guesses
  end

  def new_guess
    dao.new_guess
  end

  def create guess_attributes
    guess = dao.create_guess(guess_attributes)

    meth = guess.valid? ? :create_success : :create_failure

    framework.send meth, guess
  end

  def edit id
    dao.find_guess id
  end

  def destroy id
    dao.destroy_guess id
  end

  def update id, attributes
    guess = dao.update_guess id, attributes

    meth = guess.valid? ? :update_success : :update_failure
    framework.send meth, guess
  end
end
