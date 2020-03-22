CREATE TABLE IF NOT EXISTS `git_host_settings`
(
    `id`                      bigint(22)   NOT NULL AUTO_INCREMENT,
    `DT_CREATE`               timestamp    NOT NULL DEFAULT current_timestamp(),
    `USER_CREATE`             varchar(320)          DEFAULT NULL,
    `USER_UPDATE`             varchar(320)          DEFAULT NULL,
    `DT_UPDATE`               datetime              DEFAULT NULL,
    `hostname`                varchar(750) NOT NULL,
    `REMARKS`                 longtext              DEFAULT NULL,
    `DEFAULT_ACCOUNT_SSH_KEY` varchar(100)          DEFAULT NULL,
    `DEFAULT_ACCOUNT_TOKEN`   varchar(100)          DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `PK_GIT_HOST_SETTINGS` (`id`),
    UNIQUE KEY `UK_GHS_HOSTNAME` (`hostname`)
) ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

insert into core_classes (package_name, name, service_class_name, caption_key, form_class_name, container_class_name,
                          edit_in_popup, popup_width, popup_height)
values ('com.infraxys.base.githostsettings', 'GitHostSettings', 'com.infraxys.base.githostsettings.GitHostSettingsServiceImpl', 'Teams',
        'com.infraxys.base.githostsettings.GitHostSettingsForm',
        'com.infraxys.base.githostsettings.GitHostSettings', 1, 400, 500);


insert into core_class_attributes (core_class_id, name, type_class_name, caption_key, detail_form_column,
                                   detail_form_order, required, clone_attribute, auto_export_to_script,
                                   filter_in_suggest,
                                   visibility_level, writability, order_order, list_order)
values ((select id from core_classes where name = 'GitHostSettings'), 'hostname', 'java.lang.String', 'Name', 1, 1000, 1, 1, 1, 0,
        'ALWAYS VISIBLE', 'NEVER', 100, 100);


update containers
set module_branch_id = (select module_branch_id from environments where id = containers.environment_id)
where exists(select module_branch_id
             from environments
             where module_branch_id is not null
               and id = containers.environment_id);


update core_class_attributes
set writability = 'AT CREATION TIME'
where name = 'name'
  and core_class_id = (select id from core_classes where name = 'CoreClassAttribute');

commit;