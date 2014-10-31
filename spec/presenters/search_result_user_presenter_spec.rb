require 'spec_helper'

describe SearchResult::UserPresenter do
  let(:admin)  { double 'admin', name: "Admin", id: 1 }
  let(:user_1)   { double 'user', name: "Geoff",  id: 2  }
  let(:user_2) { double 'user', name: "Tina",  id: 3  }

  before do
    presenter.stub(:template).and_return 'template'
  end

  context "Search results for Experts" do
    let(:results) do
      {
        "CSS" => [admin, user_1], "HTML" => [admin]
      }
    end

    let(:presenter) { SearchResult::UserSkillPresenter.new results, "Experts" }
    let(:admin_css)           { {title: "Admin", media_type: "User", value: "CSS",          url: "/users/1"} }
    let(:user_css)            { {title: "Geoff", media_type: "User", value: "CSS",          url: "/users/2"} }
    let(:admin_html)          { {title: "Admin", media_type: "User", value: "HTML",         url: "/users/1"} }

    specify do
      presenter.format.should ==
        {
        name: '',
        local: [admin_css, user_css, admin_html],
        header: "<h3>Experts</h3>",
        template: "template"
      }
    end
  end

  let(:user_architecture)   { {title: "Tina", media_type: "User", value: "Architecture", url: "/users/3"} }
  let(:admin_architecture)  { {title: "Admin", media_type: "User", value: "Architecture", url: "/users/1"} }


  context "search results for users" do
    let(:results) do
      [admin, user_1]
    end

    let(:admin_result)  { {title: "Admin", media_type: "User", value: "Admin", url: "/users/1"} }
    let(:user_result)   { {title: "Geoff", media_type: "User", value: "Geoff", url: "/users/2"} }

    let(:presenter) { SearchResult::UserPresenter.new results, "Users" }
    specify do
      presenter.format.should ==
        {
        name: '',
        local: [admin_result, user_result],
        header: "<h3>Users</h3>",
        template: "template"
      }
    end
  end
end


