class GitlabMergeRequest < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes
  
  validates :gitlab_url, :allow_blank => true, :format => URI::regexp(%w(http https))
  validates :assignee_id, :numericality => true, :allow_blank => true
  validates :milestone_id, :numericality => true, :allow_blank => true
  
  safe_attributes :gitlab_url, :project_name, :assignee_id, :milestone_id, :source, :target, :use_parent_settings 
  
  
  def buildUrl(issue)
    gitlab_url = self.gitlab_url
    gitlab_url = Setting.plugin_redmine_gitlab_merge_request['gitlab_url'] if gitlab_url.blank?
    
    if gitlab_url.blank? || self.project_name.blank?
      return ''
    end
    
    id = issue.id
    title = URI.encode("#{issue.subject} ##{id}")
    
    source = self.replaceValue(self.source, id, title) unless self.source.blank?
    target = self.replaceValue(self.target, id, title) unless self.target.blank?
    
    
    url = "#{gitlab_url}/#{self.project_name}/merge_requests/new?merge_request[title]=#{title}"
    url = "#{url}&merge_request[source_branch]=#{source}" if source.present?
    url = "#{url}&merge_request[target_branch]=#{target}" if target.present?
    url = "#{url}&merge_request[assignee_id]=#{self.assignee_id}" unless self.assignee_id.blank?
    url = "#{url}&merge_request[milestone_id]=#{self.milestone_id}" unless self.milestone_id.blank?
    
    return url
  end
  
  def replaceValue(val, id, title)
    return URI.encode(val.gsub(/\:id/, id.to_s).gsub(/\:title/, title.to_s))
  end
  
end
