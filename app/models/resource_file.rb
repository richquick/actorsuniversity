class ResourceFile < ActiveRecord::Base
  belongs_to :lesson
  mount_uploader :resource_file, ResourceFileUploader

  #prevent multiple uploads for same lesson
  validates :resource_file, presence: true

  delegate :url, to: :resource_file, prefix: true

  def extension
    resource_file.file.extension
  end

  def filename_without_path
    resource_file.file.filename
  end

  def self.from_token token
    where(lesson_token: token).last
  end
end
