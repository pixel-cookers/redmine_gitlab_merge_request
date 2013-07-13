class CreateGitlabMergeRequests < ActiveRecord::Migration
  def change
    create_table :gitlab_merge_requests do |t|
      t.integer :project_id
      t.string :gitlab_url
      t.string :project_name
      t.integer :assignee_id
      t.integer :milestone_id
      t.string :source
      t.string :target
      t.boolean :use_parent_settings
    end
  end
end
