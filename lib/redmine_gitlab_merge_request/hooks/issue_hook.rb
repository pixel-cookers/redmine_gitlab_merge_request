class GitlabMergeRequestIssueHook < Redmine::Hook::ViewListener
  
  def view_issues_show_description_bottom(context = { })
    if User.current.allowed_to? :new_gitlab_merge_request, context[:project]
      merge_request = GitlabMergeRequest.find_by_project_id(context[:project].id)
      if merge_request.blank?
        return ""
      end
      
      url = merge_request.buildUrl(context[:issue])
      if url.blank?
        return ""
      end
  
      return "<hr /><a class=\"icon icon-add\" target=\"_blank\" href=\"#{url}\">#{l(:new_merge_request)}</a>"
    end
  end
end
