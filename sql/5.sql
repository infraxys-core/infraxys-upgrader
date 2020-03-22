alter table git_host_settings
    ADD COLUMN `USER_NAME` VARCHAR(250) NULL DEFAULT NULL;
alter table git_host_settings
    ADD COLUMN `USER_EMAIL` VARCHAR(250) NULL DEFAULT NULL;
