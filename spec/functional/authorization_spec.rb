require 'spec_helper'

describe Authorization do
  let(:user) { double 'user', admin?: admin, has_role?: has_role? }
  let(:has_role?) { false }

  let(:session) { {} }
  subject(:authorization) do
    Authorization.new current_user: user, session: session
  end


  context "ordinarily as a user" do
    let(:admin) { false }

    its(:admin?) { should be_false }
    its(:non_admin_user?) { should be_true }
  end

  context "ordinarily as an admin" do
    let(:admin) { true }

    its(:admin?) { should be_true }
    its(:non_admin_user?) { should be_false }
  end

  context "admin spoofing a user" do
    let(:has_role?) { true }
    let(:admin) { true }
    let(:session) { {spoofed_role: "user" } }

    its(:admin?) { should be_false }
    its(:non_admin_user?) { should be_true }

    describe "spoof! and unspoof!" do
      let(:session) { {} }

      specify do
        authorization.spoof! "egg"
        authorization.admin?.should be false

        authorization.unspoof!
        authorization.admin?.should be true
      end
    end
  end

  context "user trying to spoof an admin" do
    let(:has_role?) { false }
    let(:admin) { false }
    let(:session) {{}  }

    its(:admin?) { should be_false }
    its(:non_admin_user?) { should be_true }

    describe "spoof! and unspoof!" do
      specify do
        expect{authorization.spoof! "admin"}.to raise_error Authorization::Unauthorized
        authorization.should_not be_admin
      end

      specify do
        authorization.unspoof!
        authorization.should_not be_admin
      end

    end
  end
end
