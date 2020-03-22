alter table git_host_settings
    ADD COLUMN if not exists `USER_NAME` VARCHAR(250) NULL DEFAULT NULL;
alter table git_host_settings
    ADD COLUMN if not exists `USER_EMAIL` VARCHAR(250) NULL DEFAULT NULL;
