class UserLink < ActiveRecord::Base
  belongs_to :user
  validate :url, :link_type, presence: true


end
