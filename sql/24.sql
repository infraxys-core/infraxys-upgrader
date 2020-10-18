insert into core_classes (package_name, name, service_class_name, caption_key, form_class_name, container_class_name,
                          edit_in_popup, popup_width, popup_height)
values ('com.infraxys.base.action.actionlink', 'ActionLink',
        'com.infraxys.base.action.actionlink.ActionLinkServiceImpl', 'Aliasses', '',
        'com.infraxys.base.action.actionlink.ActionLink', 1, 400, 500);


insert into core_class_attributes (core_class_id, name, type_class_name, caption_key, detail_form_column,
                                   detail_form_order, required, clone_attribute, auto_export_to_script,
                                   filter_in_suggest,
                                   visibility_level, writability, order_order, list_order)
values ((select id from core_classes where name = 'ActionLink'), 'linkAlias', 'java.lang.String', 'Action alias', 1, 1000, 1, 1, 1, 0,
        'ALWAYS VISIBLE', 'ALWAYS', 100, 100);


insert into core_class_attributes (core_class_id, name, type_class_name, caption_key, detail_form_column,
                                   detail_form_order, required, clone_attribute, auto_export_to_script,
                                   filter_in_suggest,
                                   visibility_level, writability, order_order, list_order)
values ((select id from core_classes where name = 'Account'), 'status', 'java.lang.String', 'Status', 1, 1000, 1, 1, 1, 0,
        'ALWAYS VISIBLE', 'ALWAYS', 300, 300);

update core_class_attributes set caption_key = 'Caption' where caption_key = 'Label' and core_class_id = (select id from core_classes where name = 'PacketFile');
