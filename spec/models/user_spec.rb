require 'spec_helper'

describe User do
  let(:user) { Fabricate :user }

  describe "#pseudo_group" do
    specify do
      user = Fabricate :user

      user.should be_persisted

      user.groups.should be_empty #make another fabricator if not

      user.pseudo_group.should be_a Group
      user.reload.pseudo_group.should be_a Group

      #default scope ignores pseudo_group
      user.groups.count.should == 0

      Group.pseudo.count.should == 1
    end
  end
end


