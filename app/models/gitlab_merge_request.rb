class GitlabMergeRequest < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes
  
  belongs_to :project
  
  validates :gitlab_url, :allow_blank => true, :format => URI::regexp(%w(http https))
  validates :assignee_id, :numericality => true, :allow_blank => true
  validates :milestone_id, :numericality => true, :allow_blank => true
  
  safe_attributes :gitlab_url, :project_name, :assignee_id, :milestone_id, :source, :target, :use_parent_settings 
  
  
  def buildUrl(issue)
    gitlab_url, project_name, id, title, source, target, assignee_id, milestone_id = urlParams(issue) 
      
    if gitlab_url.blank? || project_name.blank?
      return ''
    end
    
    url = "#{gitlab_url}/#{project_name}/merge_requests/new?merge_request[title]=#{title}"
    url = "#{url}&merge_request[source_branch]=#{source}" unless source.blank?
    url = "#{url}&merge_request[target_branch]=#{target}" unless target.blank?
    url = "#{url}&merge_request[assignee_id]=#{assignee_id}" unless assignee_id.blank?
    url = "#{url}&merge_request[milestone_id]=#{milestone_id}" unless milestone_id.blank?
    
    return url
  end
  
  def urlParams(issue)
    if self.use_parent_settings && self.project.child?
      return getParent().urlParams(issue)
    end
  
    gitlab_url = self.gitlab_url
    gitlab_url = Setting.plugin_redmine_gitlab_merge_request['gitlab_url'] if gitlab_url.blank?
   
    id = issue.id
    title = URI.encode("#{issue.subject} ##{id}")
    
    source = self.replaceValue(self.source, id, title) unless self.source.blank?
    target = self.replaceValue(self.target, id, title) unless self.target.blank?
    
    return gitlab_url, self.project_name, id, title, source, target, self.assignee_id, self.milestone_id
  end
  
  def replaceValue(val, id, title)
    return URI.encode(val.gsub(/\:id/, id.to_s).gsub(/\:title/, title.to_s))
  end
  
  def getParent()
    return GitlabMergeRequest.find_or_initialize_by_project_id(:project_id => self.project.parent.id)
  end
  
end
