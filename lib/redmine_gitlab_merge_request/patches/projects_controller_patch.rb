module RedmineGitlabMergeRequest
  module Patches
    module ProjectsControllerPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable # Send unloadable so it will not be unloaded in development
                 
          alias_method_chain :settings, :merge_request
        end

      end

      module InstanceMethods
        def settings_with_merge_request
          settings_without_merge_request
          @merge_request = GitlabMergeRequest.find_or_initialize_by_project_id(:project_id => @project.id)
        end
      end

    end
  end
end

ActionDispatch::Reloader.to_prepare do   
  unless ProjectsController.included_modules.include?(RedmineGitlabMergeRequest::Patches::ProjectsControllerPatch)
    ProjectsController.send(:include, RedmineGitlabMergeRequest::Patches::ProjectsControllerPatch)
  end
end