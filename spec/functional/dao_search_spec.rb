require 'spec_helper'

describe Dao::Search do
  let(:dao) { Dao::Search.new }

  let!(:user) { Fabricate :user }
  let!(:admin) { Fabricate :admin }

  context "tagging" do
    before do
      user.tag admin, with: "bossy,obnoxious,stupid", on: "skills"
      admin.tag user, with: "lazy,insubordinate,stupid", on: "skills"
    end

    specify do
      results = dao.users_by(:skills).first

      {"bossy"         => [admin],
       "obnoxious"     => [admin],

       "stupid"        => [admin, user],

       "lazy"          => [ user],
       "insubordinate" => [ user]}.each do |type, expected|
         results[type].flatten.should =~ expected
       end
    end
  end

  context do
    let!(:course) { Fabricate :course }
    let!(:lesson) { Fabricate :lesson }

    specify do
      results = dao.prepopulate
      results["Course"].should == [course]
      results["Lesson"].should == [lesson]
    end
  end

  context do
    let!(:user) { Fabricate :user }
    let!(:admin) { Fabricate :admin }

    before do
      user.tag admin, with: "bossy,obnoxious,stupid", on: "skills"
      admin.tag user, with: "lazy,insubordinate,stupid", on: "skills"
    end

    specify do
      results = dao.prepopulate
      results["User"]["skills"]["bossy"].should =~ [admin]
      results["User"]["skills"]["stupid"].should =~ [admin, user]
    end
  end


end

