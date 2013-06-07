Gitlab Merge Request
====================

This plugin allow you to add a "New merge request" link on redmine issue.
This link will prefil Gitlab Merge Request form base on project configuration

The title of the MR will be "issue title #issueID"
The source branch can be configurated with a patern (e.g. "feature-:id" => "feature-123")
The target branch can also be configurated  (e.g. "master")
The assignee id, and mileston id or the other field that can be configurated per project


TODO :
~~~~~~

* Add module with permission
* Auto generate custom fields or move to a model
* Put link in action menu
* Use gitlab API to show current Merge request with link