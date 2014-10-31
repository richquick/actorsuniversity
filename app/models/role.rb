class Role < ActiveRecord::Base
  has_many :user_roles
  has_many :users, through: :user_roles

  def self.for_select
    @for_select ||= all.map{|r| [r.name, r.id]}
  end

  def self.admin
    Role.find_or_create_by name: "admin"
  end
end
