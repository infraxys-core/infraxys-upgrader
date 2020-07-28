ALTER TABLE `infraxys`.`actions`
    DROP COLUMN if exists `action_version_revision`,
    DROP COLUMN if exists `action_version_minor`,
    DROP COLUMN if exists `action_version_major`,
    DROP COLUMN if exists `action_version_build`,
    DROP COLUMN if exists `PACKET_VERSION_BUILD`,
    DROP COLUMN if exists `PACKET_VERSION_REV`,
    DROP COLUMN if exists `PACKET_VERSION_MINOR`,
    DROP COLUMN if exists `PACKET_VERSION_MAJOR`,
    ADD COLUMN  if not exists `packet_file_sha` VARCHAR(128) NULL DEFAULT NULL,
    ADD COLUMN  if not exists `instance_sha`    VARCHAR(128) NULL DEFAULT NULL;


alter table actions
    drop column if exists packet_and_file_sha;

ALTER TABLE `infraxys`.`action_logs`
    ADD COLUMN if not exists `packet_file_guid` VARCHAR(750) NULL DEFAULT NULL AFTER `environment_guid`;

ALTER TABLE `infraxys`.`action_logs`
    ADD COLUMN if not exists `workflow_run_guid` VARCHAR(750) NULL DEFAULT NULL AFTER `environment_guid`;

CREATE TABLE if not exists `run_history`
(
    `id`                 bigint(22)   NOT NULL AUTO_INCREMENT,
    `DT_CREATE`          timestamp    NOT NULL DEFAULT current_timestamp(),
    `USER_CREATE`        varchar(320)          DEFAULT NULL,
    `USER_UPDATE`        varchar(320)          DEFAULT NULL,
    `DT_UPDATE`          datetime              DEFAULT NULL,
    `run_guid`           varchar(750) NOT NULL,
    `workflow_guid`      varchar(750) NULL,
    `packet_file_guid`   varchar(750) NOT NULL,
    `instance_guid`      varchar(750) NOT NULL,
    `container_guid`     varchar(750) NOT NULL,
    `environment_guid`   varchar(750)          DEFAULT NULL,
    `module_branch_path` varchar(750)          DEFAULT NULL,
    `REMARKS`            longtext              DEFAULT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY `PK_RUN_HISTORY` (`id`),
    KEY `IDX_RH_PATH` (`module_branch_path`, `environment_guid`, `instance_guid`, `packet_file_guid`),
    KEY `IDX_RH_WORKFLOW` (`workflow_guid`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = latin1;

CREATE TABLE if not exists `run_history_details`
(
    `id`             bigint(22)  NOT NULL AUTO_INCREMENT,
    `DT_CREATE`      timestamp   NOT NULL DEFAULT current_timestamp(),
    `USER_CREATE`    varchar(320)         DEFAULT NULL,
    `USER_UPDATE`    varchar(320)         DEFAULT NULL,
    `DT_UPDATE`      datetime             DEFAULT NULL,
    `run_history_id` bigint(22)  NOT NULL,
    `item_order`     double      NOT NULL,
    `status_code`    varchar(50) NOT NULL,
    `REMARKS`        longtext             DEFAULT NULL,
    PRIMARY KEY (`id`),
    KEY `FK_RHD_RH` (`run_history_id`),
    CONSTRAINT `FK_RHD_RH` FOREIGN KEY (`run_history_id`) REFERENCES `run_history` (`id`)
) ENGINE = InnoDB
  AUTO_INCREMENT = 1
  DEFAULT CHARSET = latin1;

ALTER TABLE `infraxys`.`action_schedules`
    ADD COLUMN if not exists `packet_guid` VARCHAR(750) NULL DEFAULT NULL;

ALTER TABLE `infraxys`.`action_schedules`
    ADD COLUMN if not exists `packet_module_branch_path` VARCHAR(750) NULL DEFAULT NULL;

ALTER TABLE `infraxys`.`action_links`
    ADD COLUMN if not exists `packet_guid` VARCHAR(750) NULL DEFAULT NULL;

ALTER TABLE `infraxys`.`action_links`
    ADD COLUMN if not exists `packet_module_branch_path` VARCHAR(750) NULL DEFAULT NULL;
