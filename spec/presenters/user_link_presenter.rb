require 'spec_helper'

describe UserLink::Presenter do
  let(:url) { "twitter.com/jacksilver" }
  let(:user_link) { double url: url, link_type: "twitter" }
  let(:presenter) { UserLink::Presenter.for user_link }
  subject { presenter }

  it do
    should be_a UserLink::TwitterPresenter
  end

  its(:formatted_url) do
    should == "https://twitter.com/jacksilver"
  end

  context "with handle only" do
    let(:url) { "jacksilver" }

    its(:formatted_url) do
      should == "https://twitter.com/jacksilver"
    end
  end
end

