ALTER TABLE `infraxys`.`version_history`
    DROP COLUMN if exists `releaseNumber`;
ALTER TABLE `infraxys`.`version_history`
    DROP COLUMN if exists `infraxysVersion`;

alter table projects
    ADD COLUMN if not exists `enable_cache_for_child_projects` INT(1)       NOT NULL DEFAULT '0',
    ADD COLUMN if not exists `cache_alias`                     VARCHAR(100) NULL     DEFAULT NULL,
    ADD UNIQUE KEY IF NOT EXISTS `UK_PROJECT_CACHE_ALIAS` (`cache_alias`);


insert into core_class_attributes (core_class_id, name, type_class_name, caption_key, detail_form_column,
                                   detail_form_order, required, clone_attribute, auto_export_to_script,
                                   filter_in_suggest, tooltip,
                                   visibility_level, writability, order_order, list_order)
values ((select id from core_classes where name = 'Project'), 'enableCacheForChildProjects', 'java.lang.Boolean',
        'Enable cache in child projects', 1, 200, 1, 1, 1,
        0, 'Check this box if all child projects should be able to read from this cache (not write)', 'ALWAYS VISIBLE',
        'ALWAYS', 200, 200),
       ((select id from core_classes where name = 'Project'), 'cacheAlias', 'java.lang.String', 'Cache alias',
        1, 300, 0, 1, 1, 0,
        'Enter a unique cache alias. This cache will be available at /cache/shared/<alias> (the current project is always writeable at /cache/project)',
        'ALWAYS VISIBLE', 'ALWAYS', 200, 200);


