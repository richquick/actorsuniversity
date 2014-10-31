require 'fast_spec_helper'
require './app/services/user_administration'

describe UserAdministration do
  let(:user)    { double 'user', valid?: true }
  let(:dao)     { Dao::User.new }

  let(:framework) do
    double 'framework',
      update_success: nil,
      update_failure: nil,
      create_success: nil,
      create_failure: nil
  end

  let(:user_administrator) do
    UserAdministration.new framework, dao 
  end

  describe "#update" do
    let(:user) do
      admin = Fabricate :admin 
      admin.roles << Role.create!(name: 'test')
      admin
    end

    let(:user_role_admin) do
      user.user_roles[0]
    end

    let(:user_role_test) do
      user.user_roles[1]
    end

    let(:role_trainer) do
      Role.create! name: 'trainer'
    end

    let(:role_manager) do
      Role.create! name: 'manager'
    end

    let(:user_attributes) do
      {
        "name"=>"Mike",
        "email"=>"mike@actorsuniversity.com",
        "user_roles_attributes"=>{
            "0"=> #deleted
          {"role_id"=>"#{user_role_admin.role_id}", "_destroy"=>"1", "id"=>"#{user_role_admin.id}"}, 

            "1"=> #changed
          {"role_id"=>"#{role_manager.id}", "id"=>"#{user_role_test.id}"}, 

            "2"=> #added
          {"role_id"=>"#{role_trainer.id}", "id"=>""}, 

          "1385640656639"=> #ignored
          {"role_id"=>"", "_destroy"=>"1"}
        }
      }
    end

    it '' do
      user.roles.map(&:name).should =~ %w(admin test)

      user_administrator.update user.id, user_attributes
      user.reload
      user.roles.map(&:name).should =~ %w(manager trainer)
    end
  end
end
