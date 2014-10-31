require 'spec_helper'

describe Role do
  describe ".admin" do
    specify do
      role = Role.admin
      role.should be_a Role
      role.name.should == "admin"
    end
  end
end
