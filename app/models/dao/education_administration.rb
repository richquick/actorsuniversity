module Dao
  class EducationAdministration
    def new_course_to_group course_id=nil, group_id=nil
      new_assignment :course, course_id, :group, group_id
    end

    def new_course_to_exam course_id=nil, exam_id=nil
      new_assignment :course, course_id, :exam, exam_id
    end

    def new_lesson_to_course  lesson_id=nil, course_id=nil
      new_assignment :lesson, lesson_id, :course, course_id
    end

    def new_user_to_group user_id=nil, group_id=nil
      new_assignment :user, user_id, :group, group_id
    end

    def new_lesson_to_group lesson_id=nil, group_id=nil
      new_assignment :lesson, lesson_id, :group, group_id
    end

    def new_assignment assignee_type, assignee_id, assign_to_type, assign_to_id
      raise ArgumentError if assignee_id.nil? && assign_to_id.nil?

      if assignee_id
        build_assignment assignee_type, assignee_id, assign_to_type
      elsif assign_to_id
        build_assignment assign_to_type, assign_to_id, assignee_type
      end
    end

    def build_assignment a_type, a_id, b_type
      meth = "allocation_#{a_type}_to_#{b_type}s"

      model = klassify(a_type).find(a_id)

      unless model.respond_to? meth
        meth = "allocation_#{b_type}_to_#{a_type}s"
      end

      model.send(meth).build({b_type => klassify(b_type).new})
    end

    def klassify k
      "::#{k.to_s.camelize}".constantize
    end

    def assign_user_to_group user_id, group_id
      assign_a_to_b ::User, user_id, ::Group, group_id
    end

    def assign_a_to_b a_klass, a_id, b_klass, b_id
      a = if a_id.is_a? ActiveRecord::Base
        a_id
      else
        a_klass.find(a_id)
      end

      b = if b_id.is_a? ActiveRecord::Base
        b_id
      else
        b_klass.find(b_id)
      end

      attributes = {
        a_klass.name.downcase.to_sym => a,
        b_klass.name.downcase.to_sym => b
      }

      "Allocation::#{a_klass.name}To#{b_klass.name}".constantize.create! attributes
    end

    def unassign_user_from_group user_id, group_id
      unassign_a_from_b ::User, user_id, ::Group, group_id
    end

    def assign_course_to_exam course_id=nil, exam_id=nil
      assign_a_to_b ::Course, course_id, ::Exam, exam_id
    end

    def assign_course_to_group course_id, group_id
      assign_a_to_b ::Course, course_id, ::Group, group_id
    end

    def unassign_a_from_b a_klass, a_id, b_klass, b_id
      klass = "Allocation::#{a_klass.name}To#{b_klass.name}".constantize

      attributes = {
        "#{a_klass.name.downcase.to_sym}_id" => a_id,
        "#{b_klass.name.downcase.to_sym}_id" => b_id
      }


      klass.where(attributes).destroy_all
    end

    def unassign_user_from_course user_id, course_id
      user = ::User.find(user_id)
      group_id = user.pseudo_group.id

      unassign_course_from_group course_id, group_id
    end

    def unassign_course_from_group course_id, group_id
      unassign_a_from_b ::Course, course_id, ::Group, group_id
    end

    def assign_lesson_to_course lesson_id, course_id
      assign_a_to_b ::Lesson, lesson_id, ::Course, course_id
    end

    def unassign_lesson_from_course lesson_id, course_id
      unassign_a_from_b ::Lesson, lesson_id, ::Course, course_id
    end

    module PseudoAssignment
      # Pseudo-relationships
      # The principle here is that we want to assign
      # lessons to groups, without them belonging to a
      # course. But for simplicity in modelling we'll
      # transparently assign them to a course that never
      # is seen in the UI
      def assign_lesson_to_group lesson_id, group_id
        lesson = ::Lesson.find(lesson_id)

        assign_a_to_b ::Course, lesson.pseudo_course, ::Group, group_id
      end

      def assign_user_to_course user_id, course_id
        user = ::User.find(user_id)
        assign_a_to_b ::Course, course_id, ::Group, user.pseudo_group
      end

      def new_user_to_course user_id, course_id
        if user_id
          user = ::User.find(user_id)
          group = user.pseudo_group
          allocation = group.allocation_course_to_groups.build
          allocation.build_course
          allocation


        elsif course_id
          raise NotImplemented
        end
      end

      def assign_lesson_to_user lesson_id, user_id
        lesson = ::Lesson.find(lesson_id)
        user  = ::User.find(user_id)

        assign_a_to_b ::Course, lesson.pseudo_course, ::Group, user.pseudo_group
      end
    end

    include PseudoAssignment #Methods grouped for documentation only
  end
end
