class Lesson < ActiveRecord::Base
  include UrlValidation
  acts_as_taggable
  acts_as_commentable :public, :private

  validates :title, :description, presence: true
  validate :valid_url_or_resource_file, :only_url_or_resource_file

  has_many :allocation_lesson_to_courses,
    class_name: "Allocation::LessonToCourse"
  has_many :courses, through: :allocation_lesson_to_courses

  def groups_with_pseudo
    courses.with_pseudo.map{|c| c.groups.with_pseudo }.flatten
  end

  has_many :lesson_completions

  def users
    groups_with_pseudo.map(&:users).flatten
  end

  class << self
    def archive! id
      set_archival id, true
    end

    def unarchive! id
      set_archival id, false
    end

    private

    def set_archival id, state
      find(id).update_attributes(archived: state)
    end
  end


  has_one :resource_file

  letsrate_rateable :difficulty, :enjoyment

  def url
    #TECHDEBT
    resource_file.url rescue external_resource_url
  end

  def filename
    resource_file.resource_file.to_s if file?
  end

  def filename_without_path
    resource_file.filename_without_path if file?
  end

  def file_type
    extension.present? ? extension : :link
  end

  def extension
    resource_file.extension if file?
  end

  def only_url_or_resource_file
    if file? && valid_url?
      errors[:base] << "Can't have a URL and a file in the same lesson"
    end
  end

  #TECHDEBT - move instantiation to controller and remove delegation
  def presenter
    @presenter ||= LessonPresenterSelector.for(self)
  end

  delegate :formatted_url, to: :presenter
  delegate :resource_file_url, to: :resource_file

  def file?
    resource_file.try :valid?
  end

  def pseudo_course
    @pseudo_course ||= courses.pseudo.first || new_pseudo_course
  end

  private

  def new_pseudo_course
    allocation = allocation_lesson_to_courses.build

    allocation.build_course(pseudo: true).tap do |c|
      c.save validate: false
      allocation.save
    end
  end


end
