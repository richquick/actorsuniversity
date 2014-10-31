class Following < ActiveRecord::Base
  belongs_to :follower, class_name: User, foreign_key: :follower_id
  belongs_to :pursued,  class_name: User, foreign_key: :pursued_id

  validates :follower_id, uniqueness: {scope: :pursued_id}
  validates :pursued_id,  uniqueness: {scope: :follower_id}
end
