class MergeRequestController < ApplicationController
  menu_item :settings
  before_filter :find_project, :authorize

  # Create or update a project's merge request settings
  def edit
    if User.current.allowed_to? :manage_gitlab_merge_request, @project
      @merge_request = GitlabMergeRequest.find_or_initialize_by_project_id(:project_id => @project.id)
      @merge_request.safe_attributes = params[:merge_request]
      @merge_request.save if request.post?
    end
  end


end