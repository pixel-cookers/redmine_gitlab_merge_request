require 'redmine'

Redmine::Plugin.register :redmine_gitlab_merge_request do
  name 'Gitlab Merge Request'
  author 'Jeremie Augustin'
  description 'Add "new merge request" link that auto fill info on gitlab merge request page'
  version '0.0.1'

  requires_redmine :version_or_higher => '2.0.0'
  
  settings :default => {
    'gitlab_url' => '',
    'gitlab_url_field' => '',
    'gitlab_project_name_field' => '',
    'gitlab_assignee_id_field' => '',
    'gitlab_milestone_id_field' => '',
    'gitlab_source_branch_field' => '',
    'gitlab_target_branch_field' => '',
  }, :partial => 'settings/gitlab_settings'
  
end


class GitlabMergeRequestIssueHook < Redmine::Hook::ViewListener
  def view_issues_show_description_bottom(context = { })
    project_name = context[:project].custom_values.detect {|v| v.custom_field_id == Setting.plugin_redmine_gitlab_merge_request['gitlab_project_name_field'].to_i}
    project_name = project_name.value if project_name 

    gitlab_url = context[:project].custom_values.detect {|v| v.custom_field_id == Setting.plugin_redmine_gitlab_merge_request['gitlab_url_field'].to_i}
    gitlab_url = gitlab_url.value if gitlab_url
    
    gitlab_url = Setting.plugin_redmine_gitlab_merge_request['gitlab_url'] if gitlab_url.blank?
    
    if gitlab_url.blank? || project_name.blank?
      return ''
    end

    if nil == (gitlab_url =~ /^#{URI::ABS_URI}$/)
      return '<hr /><span style="color:red">Invalid url for gitlab merge request</span>'
    end
    
    id = context[:issue].id
    title = URI.encode("#{context[:issue].subject} ##{id}")
    
    source_branch = context[:project].custom_values.detect {|v| v.custom_field_id == Setting.plugin_redmine_gitlab_merge_request['gitlab_source_branch_field'].to_i}
    source_branch = URI.encode(source_branch.value.gsub(/\:id/, id.to_s)) if source_branch
    
    target_branch = context[:project].custom_values.detect {|v| v.custom_field_id == Setting.plugin_redmine_gitlab_merge_request['gitlab_target_branch_field'].to_i}
    target_branch = URI.encode(target_branch.value.gsub(/\:id/, id.to_s)) if target_branch
    
    assignee_id = context[:project].custom_values.detect {|v| v.custom_field_id == Setting.plugin_redmine_gitlab_merge_request['gitlab_assignee_id_field'].to_i}
    assignee_id = URI.encode(assignee_id.value) if assignee_id
    
    milestone_id = context[:project].custom_values.detect {|v| v.custom_field_id == Setting.plugin_redmine_gitlab_merge_request['gitlab_milestone_id_field'].to_i}
    milestone_id = URI.encode(milestone_id.value) if milestone_id
    
    
    merge_request = "#{gitlab_url}/#{project_name}/merge_requests/new?merge_request[title]=#{title}"
    merge_request = "#{merge_request}&merge_request[source_branch]=#{source_branch}" if source_branch.present?
    merge_request = "#{merge_request}&merge_request[target_branch]=#{target_branch}" if target_branch.present?
    merge_request = "#{merge_request}&merge_request[assignee_id]=#{assignee_id}" if assignee_id.present?
    merge_request = "#{merge_request}&merge_request[milestone_id]=#{milestone_id}" if milestone_id.present?
    

    return "<hr /><a class=\"icon icon-add\" href=\"#{merge_request}\">New Merge Request</a>"
  end

end