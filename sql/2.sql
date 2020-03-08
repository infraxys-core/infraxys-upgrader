CREATE TABLE `db_version_history`
(
    `DT_CREATE` timestamp   NOT NULL DEFAULT current_timestamp(),
    `VERSION`   int(10) NOT NULL,
    PRIMARY KEY (`VERSION`)
) ENGINE = InnoDB
  DEFAULT CHARSET = latin1;

update core_classes set popup_width = 800, popup_height = 400 where name = 'Module';
update accounts set status = 'ACTIVE' where status is null or status = 'active';
delete from menu_items where caption_key = 'Flush cache';
ALTER TABLE `infraxys`.`packet_files` DROP INDEX `UK_PF_GUID` ;
ALTER TABLE `infraxys`.`packet_files`  ADD INDEX `PF_GUID` (`guid` ASC);
ALTER TABLE `infraxys`.`environments` DROP INDEX `UK_ENVIRONMENT_GUID` ;
ALTER TABLE `infraxys`.`environments`  ADD INDEX `ENVIRONMENT_GUID` (`guid` ASC);
ALTER TABLE `infraxys`.`instances` DROP INDEX `UK_INSTANCE_GUID` ;
ALTER TABLE `infraxys`.`instances`  ADD INDEX `INSTANCE_GUID` (`guid` ASC);

CREATE or replace
    VIEW `packet_files_vw` AS
SELECT
    `pf`.`id` AS `id`,
    `pf`.`guid` AS `guid`,
    `pf`.`DT_CREATE` AS `dt_create`,
    `pf`.`USER_CREATE` AS `user_create`,
    `pf`.`DT_UPDATE` AS `dt_update`,
    `pf`.`USER_UPDATE` AS `user_update`,
    `pf`.`PACKET_ID` AS `packet_id`,
    `pf`.`VERSION` AS `version`,
    `pf`.`FILENAME` AS `filename`,
    `pf`.`FILE_OBJECT` AS `file_object`,
    `pf`.`REMARKS` AS `remarks`,
    `pf`.`CONTENT_TYPE` AS `content_type`,
    `pf`.`ALWAYS_INCLUDE` AS `always_include`,
    `pf`.`ITEM_KEY` AS `item_key`,
    `pf`.`PARSE_WITH_VELOCITY` AS `parse_with_velocity`,
    `pf`.`IS_EXECUTABLE` AS `is_executable`,
    `pf`.`NAME` AS `name`,
    `pf`.`directory_name` AS `directory_name`,
    `pf`.`execute_on_target` AS `execute_on_target`,
    `pf`.`SHARE_LABEL` AS `share_label`,
    `pf`.`INCLUDE_NAME` AS `include_name`,
    `pf`.`SESSION_TIMEOUT` AS `session_timeout`,
    `pf`.`MENU_ORDER` AS `menu_order`,
    `pf`.`MENU_SEPARATOR_BEFORE` AS `menu_separator_before`,
    `pf`.`FILE_FORMAT` AS `file_format`,
    `pf`.`ADD_TO_CONTEXT_MENU_OF` AS `add_to_context_menu_of`,
    `pf`.`HIDE_FROM_INSTANCEACTIONS_MENU` AS `hide_from_instanceactions_menu`,
    `pf`.`ACTIONS_MENU_LOCATION` AS `actions_menu_location`,
    `pf`.`RUN_IN_PARALLEL` AS `run_in_parallel`,
    `pf`.`IS_INDEPENDANT` AS `is_independant`,
    `pf`.`RUN_BEFORE_INDEPENDENT` AS `run_before_independent`,
    `pf`.`IS_INTERACTIVE` AS `is_interactive`,
    `pf`.`is_url` AS `is_url`,
    `pf`.`hide_runner_window` AS `hide_runner_window`,
    `pf`.`hide_from_bottom_menu` AS `hide_from_bottom_menu`,
    `pf`.`save_with` AS `save_with`,
    `pf`.`file_group` AS `file_group`,
    `pf`.`docker_image` AS `docker_image`,
    `pf`.`custom_command` AS `custom_command`,
    `p`.`NAME` AS `packet_name`,
    p.module_branch_id
FROM
    (`packet_files` `pf`
        JOIN `packets` `p` ON (`pf`.`PACKET_ID` = `p`.`id`));

