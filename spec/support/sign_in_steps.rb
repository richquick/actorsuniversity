module UserSignInSteps
  def sign_in type, email=nil, password="password"
    user = if email.nil? 
      Fabricate(type, password: password)
    else
      User.find_by email: email
    end

    visit "/"
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_on "Sign in"

    user
  end

  def as(user_type)
    @all_users ||= {}
    user = @all_users[user_type]
    attributes = user ? [user_type, user.email, user.password] : [user_type]

    returned_user = sign_in(*attributes).tap do
      yield
      click_on "Sign out"
    end

    @all_users[user_type] ||= returned_user
  end
end
