module RedmineGitlabMergeRequest
  module Patches
    module ProjectsHelperPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)
        
        base.class_eval do
             unloadable # Send unloadable so it will not be unloaded in development
       
             alias_method_chain :project_settings_tabs, :merge_request_tab
           end
      end

      module InstanceMethods
        # Adds a rates tab to the user administration page
        def project_settings_tabs_with_merge_request_tab
          tabs = project_settings_tabs_without_merge_request_tab
          
          if User.current.allowed_to? :manage_gitlab_merge_request, @project
            tabs << { 
              :name => 'merge_request',
              :action => :mergerequest,
              :partial => 'project_settings/gitlab_settings', 
              :label => :gitlab_merge_request_tab
            }
          end
          
          return tabs
        end
      end
    end
  end
end

ActionDispatch::Reloader.to_prepare do  
  unless ProjectsHelper.included_modules.include?(RedmineGitlabMergeRequest::Patches::ProjectsHelperPatch)
    ProjectsHelper.send(:include, RedmineGitlabMergeRequest::Patches::ProjectsHelperPatch)
  end
end
