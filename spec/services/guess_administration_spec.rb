#Uncomment and use a separate faster spec helper  
#require 'fast_spec_helper' # i.e. don't load framework
#require './app/services/guess_administration'
#or use zeus https://github.com/burke/zeus and have the framework pre-loaded:
require 'spec_helper' 

describe GuessAdministration do
  let(:guess)    { double 'guess', valid?: validity }
  let(:validity) { true }

  let(:dao) do 
    double 'dao_guess', 
      create_guess:  guess,
      update_guess:  guess,
      find_guess:    guess,
      new_guess:     guess,
      destroy_guess: guess,
      all_guesses:                 guess
  end

  let(:framework) do
    double 'framework', 
      create_success: nil,
      create_failure: nil,
      update_success: nil,
      update_failure: nil
  end

  let(:guess_administration) { GuessAdministration.new framework, dao }

  let(:guess_attributes) do
    {}
  end

  describe "#all" do
    it "looks up the resource" do
      guess_administration.all

      expect(dao).to have_received(:all_guesses)
    end
  end

  describe "#edit" do
    it "looks up the resource" do
      guess_administration.edit 1

      expect(dao).to have_received(:find_guess).
                    with(1)
    end
  end

  describe "#new_guess" do
    it "looks up the resource" do
      guess_administration.new_guess

      expect(dao).to have_received(:new_guess)
    end
  end

  describe "#destroy" do
    it "destroys the resource" do
      guess_administration.destroy 1

      expect(dao).to have_received(:destroy_guess).
        with 1
    end
  end

  describe "#create" do
    it "creates the resource" do
      guess_administration.create guess_attributes

      expect(dao).to have_received(:create_guess).
                    with(guess_attributes)
    end

    context "with valid attributes" do
      let(:validity) { true }

      it "triggers :create_success in the framework" do
        guess_administration.create guess_attributes

        expect(framework).to have_received(:create_success).with guess
      end
    end

    context "with invalid attributes" do
      let(:validity) { false }

      it "triggers :create_failure in the framework" do
        guess_administration.create guess_attributes

        expect(framework).to have_received(:create_failure).with guess
      end
    end
  end

  describe "#update" do
    it "updates the resource" do
      guess_administration.update 1, guess_attributes

      expect(dao).to have_received(:update_guess).
                    with(1, guess_attributes)
    end

    context "with valid attributes" do
      before do
        guess.stub(:valid?).and_return true
      end

      it "triggers :update_success in the framework" do
        guess_administration.update 1, guess_attributes

        expect(framework).to have_received(:update_success).with guess
      end
    end

    context "with invalid attributes" do
      before do
        guess.stub(:valid?).and_return false
      end

      it "triggers :update_failure in the framework" do
        guess_administration.update 1, guess_attributes

        expect(framework).to have_received(:update_failure).with guess
      end
    end
  end
end
