namespace :devise do
  desc 'setup devise example migrating db and creating a default user'

  def create_user email, password
    User.find_or_create_by(email: email) do |u|
      u.password_confirmation = u.password = password
      yield u if block_given?
    end

    puts 'New user created or updated'
    puts 'Email   : ' << email
    puts 'Password: ' << password
  end

  task :setup => ['db:migrate', 'environment'] do
    password = 'hung3rg4m3s'

    create_user 'user@actorsuniversity.com', password

    create_user 'admin@actorsuniversity.com', password do |u|
      u.roles << Role.admin
    end
  end
end
