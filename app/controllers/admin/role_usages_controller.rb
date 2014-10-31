class Admin::RoleUsagesController < Admin::ApplicationController
  def create
    #TECHDEBT - if we add more roles we should have parameters for 
    #roles to spoof - this is for admin to act like a user
    authorization.spoof! "user"
    redirect_to(redirect_path)
  end

  def destroy
    authorization.unspoof!
    redirect_to(redirect_path)
  end

  def redirect_path
    dashboard_path
  end
end
