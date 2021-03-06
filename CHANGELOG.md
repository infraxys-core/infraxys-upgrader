# Infraxys changelog

This page contains important changes done to Infraxys and its supported modules.

## [3.0.144] - 2021-05-17 - [Infraxys](https://infraxys.io)

## Added
- Bux fix release
    > Bug fix release.

## [3.0.141] - 2021-04-25 - [Infraxys](https://infraxys.io)

## Added
- Immediately go to a project from an environment
    > The environment-form now contains an option to directly go to the project under which it is deployed.

## [3.0.137] - 2021-03-06 - [Infraxys](https://infraxys.io)

## Added
- Pass arbitrary JSON from an action to a client application
    > Add JSON to the open client app request and use it using the clientJson variable in JavaScript.

## [3.0.104] - 2021-01-14 - [Infraxys](https://infraxys.io)

## Added
- REST additions: download cached project files and functions for project management
    > Generate files using actions and download them using the REST API.
Get and manage user's projects using the REST API 

## [3.0.84] - 2020-11-08 - [Infraxys](https://infraxys.io)

## Added
- Create your own client applications with the framework of your choice: React, Vue, HTML and JavaScript, ...
    > Write full-blown client-side, user-friendly applications that execute actions, use cached files, ... and deploy them into a module that's enabled in Infraxys. These applications can then be activated within Infraxys using (quickrunner) actions.

## [3.0.41] - 2020-10-18 - [Infraxys](https://infraxys.io)

## Added
- Root admins can manage all action REST aliases
    > Administrators of the root project now have an extra tab with a list of all action aliases. Aliases can be changed and removed using this list.
Action REST aliasses are paths that can be used to trigger actions using the /api/v1/actions endpoint.
- Generate scripts per container
    > Generate scripts just for one or more containers instead of for the whole environment at once.
- Skip generation of files and actions
    > When Velocity variable 'skip_file_creation' is set to true while a file is generated, then the file won't be stored in the result and no action is created.
Use this to skip actions like direct 'Terraform apply' in specific environments.
Set variable 'skip_action_creation' to true if the file should be generated but no action should be created for it.
- Dynamically set the menu caption and instance label for actions
    > Set Velocity variable 'action_instance_label' for the value in the instance-column of the actions table and 'menu_caption' if you don't want to use the default caption for the action menus. Example Velocity:  
		```#set ($menu_caption = "Apply $instance.getAttribute("apply_caption")"```

## 2020-10-18 - [Terraform](https://github.com/infraxys-modules/terraform)

## Added
- New branch for Terraform 0.13.x
    > Based on the master branch.
This branch already makes use of the new options for skipping file creation.
Also added packet 'Terraform generate actions attributes' which can be extended and used to optionally generate actions.

## [3.0.30] - 2020-10-11 - [Infraxys](https://infraxys.io)

## Added
- Configure rate limits for the frontend Nginx instances
    > The following variables can be used to fine-tune rate limiting: 

| Setting | Default |
| ------- | ------- |
| GLOBAL_ZONE_LIMIT_KEY | binary_remote_addr |
 | GLOBAL_ZONE_MEMORY | 10m |
| GLOBAL_ZONE_RATE | 100r |
| ACTION_ZONE_LIMIT_KEY | binary_remote_addr |
| ACTION_ZONE_MEMORY | 10m |
| ACTION_ZONE_RATE | 100r |
| ACTION_ZONE_LIMIT_BURST | 100 |
| ACTION_ZONE_LIMIT_DELAY | 50 |

The action zone settings are for calls to /api/v1/actions. Global zone settings cover all the rest.
The Nginx container needs to be restarted to apply changes.

See [ngx_http_limit_req_module module documentation](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html) for more information.


## [3.0.24] - 2020-10-04 - [Infraxys](https://infraxys.io)

## Changed
- Minor bugfixes and improvements
    > 

## [3.0.21] - 2020-09-27 - [Infraxys Developer](https://infraxys.io)

## Changed
- [ATTENTION] Moved from HTTPS to HTTP. You need to clear your browsers cache to avoid continuous reload.
    > Infraxys Developer will run on http://localhost:<PORT> instead of https://localhost:<PORT> after this upgrade.

## [2.0.600] - 2020-09-20 - [Infraxys](https://infraxys.io)

## Added
- Add React apps, JavaScript, charts, ... or include html pages in JSON forms.
    > Copy any HTML, CSS, JavaScript, JSX, ... to the project cache and reference them in the JsonForm specification. Add an iframe that references an external site or create full-blown, dynamic D3.js graph views. A walkthrough will be added to Infraxys-by-example soon.
- You can now export JsonTables to csv files
    > An export-button is added to JsonTable components if new attribute 'enableExport' is specified with value 'true'.

## [2.0.587] - 2020-09-13 - [Infraxys](https://infraxys.io)

## Added
- JsonTables can now have columns with hyperlinks
    > Add attributes 'columnType' and 'linkField' to the column-definition of a table to make it display the values for the property with a link to the value of the linkField-attribute.

## [2.0.586] - 2020-09-12 - [Infraxys](https://infraxys.io)

## Added
- Added dialog types and options for Json Forms
    > Pass custom button lists (from Bash, Python, ...) through the FEEDBACK-process.

## [2.0.582] - 2020-09-08 - [Infraxys](https://infraxys.io)

## Added
- Add quick runners - actions without dependencies
    > When using quick runners, which is a new checkbox in the packet file view, Infraxys will launch the action directly without preparing dependencies. Only the current environment's files, arguments,json, has_grant and current_user.json are available. No modules nor variables.

## [2.0.581] - 2020-09-06 - [Infraxys](https://infraxys.io)

## Added
- Specify JSON files for tables and dropdowns in custom forms and get filter results back through files.
    > When adding a datapart for a JSON table or dropdown, you can now specify the path to a cache- or module-file.<br/>To get the contents of a table using Python, just call the store_selected_items function on the JsonForm.<br/>This is useful when the user can filter a table and perform actions against the result.<br/>Example request: <br/>```{ "requestType": "UI",
            "subType": "STORE SELECTED ITEMS",
            "objectId": object_id}```

## [2.0.568] - 2020-08-30 - [Infraxys Developer](https://infraxys.io)

## Added
- Mount host directories in action runner containers.
    > Host directories can be mounted into action containers using the 'Host mounts'-tab in the Settings-view. Use this to share files betwwen the host and all actions, like SSH configurations. Generate SSH configs for AWS VPCs, for example, and automatically make them available to the host.

## [2.0.563] - 2020-08-23 - [Infraxys](https://infraxys.io)

## Added
- Copy and move environments between branches.
    > It's now possible to copy and move environments with their containers to other branches.<br/>Be careful though, because another Infraxys environment that uses the (re)moved environment will become invalid if they have the environment attached to a project.


## Changed
- Share project cache with all child projects and the global-cache is removed.
    > Specify in the project details if the project cache should be made available (readonly) to all child projects.<br/>Enter an alias for the cache name to use for the directory. The cache will be available at /cache/project/<cache alias or at /cache/project/<project guid> if no alias is specified.<br/>This cache-sharing makes the global cache obsolete so it has been removed in this release.

## [2.0.553] - 2020-08-16 - [Infraxys](https://infraxys.io)

## Added
- Git dialog shows remote changes
    > Remote changes are inspected and displayed when a user selects a branch in the Git dialog. This helps to avoid merge conflicts.
- Project selection shows all containers in all child environments
    > When a user selects a project in the project tree, then the container-table will be loaded with all containers that below to an environment of the project or any of its children.

## [2.0.526] - 2020-08-08 - [Infraxys](https://infraxys.io)

## Added
- Auto-run workflows optional on pull
    > Workflows that are configured to run automatically after updates are done to its repository will always run when triggered through a webhook.<br/>When pulling changes manually, there's a new menu through which the workflow execution can be avoided.


## Changed
- Git pulls with local changes
    > When a branch is pulled, either directly or because it's a dependency, then the pull won't be done if there are local changes in the branch.

## [2.0.519] - 2020-08-02 - [Infraxys](https://infraxys.io)

## Added
- Multiple inheritance for packets
    > Packets can extend multiple other packets and many levels deep.<br/>Attributes and files are inherited.<br/>Extend the Terraform runner packet and inherit the plan and apply actions, for example. See [Packet](https://infraxys.io/concepts/resource-types/packet/) for more information.

## 2020-07-26 - [Terraform](https://github.com/infraxys-modules/terraform)

## Added
- Confirmers; require approval/confirmation to apply a plan.
    > Confirmers are non-default ways to require some kind of confirmation before a Terraform plan can be applied. The SES-email confirmer, for example, sends an email to one or more email-address contain the Terraform plan for review and a button to directly apply the plan.

## [2.0.514] - 2020-07-26 - [Infraxys](https://infraxys.io)

## Added
- New Python class generator
    > Attribute 'Class' is added to the packet-view.<br/>A Python class under the module-directory 'generated' will be created automatically.<br/>This class contains variables for the attributes and details about the packet.<br/>Use this, for example, to easily invoke the Infraxys REST-API to retrieve and create instances.
- 5 cache levels
    > Cache binaries, Terraform plans and provisioners, data, ... and re-use it in actions of the same instance, container, environment or project.<br/>A global cache is also available which is readable by any action, but can only be written to from actions in environments that are linked directly under the root-project.<br/>See [Cache concept](https://infraxys.io/topics/caching/) for more details.

