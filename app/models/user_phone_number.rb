class UserPhoneNumber < ActiveRecord::Base
  belongs_to :user
  validate :number, :phone_number_type, presence: true
end
