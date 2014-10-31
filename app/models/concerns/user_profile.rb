# TECHDEBT move profile related stuff into some kind of service object
# Concerns are not a great pattern, but will suffice for some kind of
# code organisation for now
module UserProfile
  extend ActiveSupport::Concern

  included do
    has_many :user_links, inverse_of: :user, dependent: :destroy
    has_many :user_phone_numbers, inverse_of: :user, dependent: :destroy

    accepts_nested_attributes_for :user_phone_numbers, reject_if: :blank_number, allow_destroy: true
    accepts_nested_attributes_for :user_links, reject_if: :blank_link, allow_destroy: true
    mount_uploader :avatar_image, ImageUploader
  end

  def set_profile_attributes! attributes
    attributes = attributes.dup
    attributes.delete(:password) if attributes[:password].blank?

    update_attributes attributes

    save
  end

  private

  def blank_number attributes
    attributes["number"].blank? || attributes["phone_number_type"].blank?
  end

  def blank_link attributes
    attributes["link_type"].blank? || attributes["url"].blank?
  end


end
