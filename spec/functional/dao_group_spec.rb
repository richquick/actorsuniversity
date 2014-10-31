require 'spec_helper'

describe Dao::Group do
  let(:dao) do
    Dao::Group.new
  end

  let(:user_1) { Fabricate :user }
  let(:user_2) { Fabricate :admin, password: 'password' }

  specify "creating a group" do
    group = dao.create name: "egg", description: "some description"
    group.should be_valid
    group.public.should be_false
  end

  specify "creating an invalid group" do
    group = dao.create name: nil, description: "some description", public: true
    group.public.should be_true
    group.should_not be_valid
  end

  specify "adding users" do
    group = dao.create name: "name", description: "some description"
    dao.add_user group.id, user_1
    dao.add_user group.id, user_2

    group.reload
    group.users.count.should == 2
  end
end
