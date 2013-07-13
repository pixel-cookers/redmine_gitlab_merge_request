#custom routes for this plugin
match 'projects/:id/gitlab_merge_request', :to => 'merge_request#edit', :via => :post