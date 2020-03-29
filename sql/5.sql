alter table git_host_settings
    ADD COLUMN if not exists `USER_NAME` VARCHAR(250) NULL DEFAULT NULL;
alter table git_host_settings
    ADD COLUMN if not exists `USER_EMAIL` VARCHAR(250) NULL DEFAULT NULL;

insert into core_class_attributes (core_class_id, name, type_class_name, caption_key, detail_form_column,
                                   detail_form_order, required, clone_attribute, auto_export_to_script,
                                   filter_in_suggest,
                                   visibility_level, writability, order_order, list_order, list_of_values)
select (select id from core_classes where name = 'GitHostSettings'),
       'defaultAccountSshKey',
       'java.lang.String',
       'Default SSH key',
       1,
       1100,
       0,
       1,
       1,
       0,
       'ALWAYS VISIBLE',
       'ALWAYS',
       100,
       100,
       '-'
where not exists(select name
                 from core_class_attributes
                 where core_class_id = (select id from core_classes where name = 'GitHostSettings')
                   and name = 'defaultAccountSshKey');

insert into core_class_attributes (core_class_id, name, type_class_name, caption_key, detail_form_column,
                                   detail_form_order, required, clone_attribute, auto_export_to_script,
                                   filter_in_suggest,
                                   visibility_level, writability, order_order, list_order, list_of_values)
select (select id from core_classes where name = 'GitHostSettings'),
       'defaultAccountToken',
       'java.lang.String',
       'Default token',
       1,
       1100,
       0,
       1,
       1,
       0,
       'ALWAYS VISIBLE',
       'ALWAYS',
       100,
       100,
       '-'
where not exists(select name
                 from core_class_attributes
                 where core_class_id = (select id from core_classes where name = 'GitHostSettings')
                   and name = 'defaultAccountToken');

insert into core_class_attributes (core_class_id, name, type_class_name, caption_key, detail_form_column,
                                   detail_form_order, required, clone_attribute, auto_export_to_script,
                                   filter_in_suggest,
                                   visibility_level, writability, order_order, list_order)
select (select id from core_classes where name = 'GitHostSettings'),
       'userName',
       'java.lang.String',
       'User name',
       2,
       2100,
       0,
       1,
       1,
       0,
       'ALWAYS VISIBLE',
       'ALWAYS',
       100,
       100
where not exists(select name
                 from core_class_attributes
                 where core_class_id = (select id from core_classes where name = 'GitHostSettings')
                   and name = 'userName');

insert into core_class_attributes (core_class_id, name, type_class_name, caption_key, detail_form_column,
                                   detail_form_order, required, clone_attribute, auto_export_to_script,
                                   filter_in_suggest,
                                   visibility_level, writability, order_order, list_order)
select (select id from core_classes where name = 'GitHostSettings'),
       'userEmail',
       'java.lang.String',
       'Email',
       2,
       2200,
       0,
       1,
       1,
       0,
       'ALWAYS VISIBLE',
       'ALWAYS',
       100,
       100
where not exists(select name
                 from core_class_attributes
                 where core_class_id = (select id from core_classes where name = 'GitHostSettings')
                   and name = 'userEmail');

update core_classes set POPUP_WIDTH = 650, POPUP_HEIGHT = 175 where name = 'GitHostSettings';

commit;