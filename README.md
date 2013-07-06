Gitlab Merge Request
====================

This plugin allow you to add a "New merge request" link on redmine issue.
Gitlab Merge Request form will be filled based on project configuration


* The `title` of the MR will be "issue_title #issueID"
* The `source branch` can be configurated with a patern (e.g. "feature-:id" for "feature-123")
* The `target branch` can also be configurated (e.g. "master")
* `assignee id`, and `milestone id` are other fields that can be configurated per project

Installation
------------

Like any redmine plugin clone this project into redmine plugin directory

```
git clone https://github.com/pixel-cookers/redmine_gitlab_merge_request plugins/redmine_gitlab_merge_request
```

You need to run the plugin migration command

```
RAILS_ENV=production rake redmine:plugins:migrate
```


TODO :


* Put link in action menu
* Use parent project's configuration
* Use gitlab API to show current Merge request with link
* Cleanup code 
* Use gilab API to select assignee/milestone from a list
