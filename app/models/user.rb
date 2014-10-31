class User < ActiveRecord::Base
  include UserProfile
  include WithoutNoisyQueries

  acts_as_tagger
  acts_as_taggable_on :skills, :interests

  letsrate_rater


  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :allocation_user_to_groups,
    class_name: "Allocation::UserToGroup"
  has_many :groups, through: :allocation_user_to_groups

  has_many :lesson_completions

  has_many :user_roles, dependent: :destroy
  has_many :roles, through: :user_roles, dependent: :destroy

  accepts_nested_attributes_for :user_roles, reject_if: :user_role_invalid?, allow_destroy: true

  has_many :follower_followings, inverse_of: :pursued, class_name: Following, foreign_key: :pursued_id
  has_many :followers, through: :follower_followings

  has_many :pursued_followings, inverse_of: :follower, class_name: Following, foreign_key: :follower_id
  has_many :pursueds, through: :pursued_followings

  def exams
    courses.map(&:exams).flatten.uniq
  end

  def inspect
    "#<User id: #{id}, email: #{email.inspect} name: #{name.inspect}>"
  end

  def admin?
    has_role? "admin"
  end

  def has_role? role_name
    #TECHDEBT - admin can do everything
    roles.any?{|r| r.name == "admin" || (r.name == role_name) }
  end

  def user_role_invalid? attrs
    attrs[:role_id].blank?
  end

  def courses
    without_noisy_queries do
      groups.with_pseudo.map do |g|
        g.courses.with_pseudo
      end.flatten.uniq
    end
  end

  def lessons
    without_noisy_queries do
      @lessons ||= courses.map(&:lessons).flatten.uniq
    end
  end

  def completed_lessons
    lesson_completions.includes(:lesson).map(&:lesson)
  end

  def pseudo_group
    @pseudo_group ||= groups.pseudo.first || new_pseudo_group
  end

  private

  def new_pseudo_group
    allocation = allocation_user_to_groups.build

    group = allocation.build_group(pseudo: true).tap do |g|
      g.save validate: false
      allocation.group_id = g.id
    end

    allocation.save!

    group
  end

end
