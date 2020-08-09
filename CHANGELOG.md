# Infraxys changelog

This page contains important changes done to Infraxys and its supported modules.

## [Unreleased] - 2020-08-08 - [Infraxys](https://infraxys.io)

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

