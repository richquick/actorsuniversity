require 'spec_helper'

describe "Admin controller namespace" do
  admin_controllers = Dir.glob(File.join(Rails.root, "app/controllers/admin/") << "**/*_controller.rb")

  admin_controllers.reject!{|f| f=~ %r{admin/application_controller.rb}}

  admin_controllers.each do |c|
    specify "#{c} should inherit from Admin::ApplicationController" do
      File.readlines(c)[0].should_not =~ /< ApplicationController/
    end
  end
end
