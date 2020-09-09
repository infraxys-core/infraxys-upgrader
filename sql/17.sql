
insert into core_class_attributes (core_class_id, name, type_class_name, caption_key, detail_form_column,
                                   detail_form_order, required, clone_attribute, auto_export_to_script,
                                   filter_in_suggest, tooltip,
                                   visibility_level, writability, order_order, list_order)
values ((select id from core_classes where name = 'PacketFile'), 'isQuickRunner', 'java.lang.Boolean',
        'Quick runner', 1, 1900, 1, 1, 1,
        0, 'Run file directly without module preparation or environment setup', 'ALWAYS VISIBLE',
        'ALWAYS', 200, 200);