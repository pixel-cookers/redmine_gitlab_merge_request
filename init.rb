require 'redmine'

Redmine::Plugin.register :redmine_gitlab_merge_request do
  name 'Gitlab merge request'
  author 'Jeremie Augustin'
  description 'Add "new merge request" link that auto fill form on Gitlab merge request page'
  version '0.0.2'

  requires_redmine :version_or_higher => '2.0.0'
  
  settings :default => {
    'gitlab_url' => ''
  }, :partial => 'settings/gitlab_settings'
  
  project_module :gitlab_merge_request do
    permission :manage_gitlab_merge_request, :merge_request => :edit
    permission :new_gitlab_merge_request, :issue => :show
  end
  
end

require 'redmine_gitlab_merge_request/hooks/issue_hook'
require 'redmine_gitlab_merge_request/patches/projects_controller_patch'
require 'redmine_gitlab_merge_request/patches/projects_helper_patch'
