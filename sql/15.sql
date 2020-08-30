insert into core_class_attributes (core_class_id, name, type_class_name, caption_key, detail_form_column,
                                   detail_form_order, required, clone_attribute, auto_export_to_script,
                                   filter_in_suggest, tooltip,
                                   visibility_level, writability, order_order, list_order)
values ((select id from core_classes where name = 'Packet'), 'packageName', 'java.lang.String',
        'Package', 2, 50, 0, 1, 1,
        0, '<p>Enter the package name under which to save the Python class. A folder-tree will be created in the module under generated/python.<br/>Example: modulex/model<br/>Add <source>export PYTHONPATH="$(pwd)/generated/python:$PYTHONPATH";</source> to an auto-source file in the module to enable this class.</p>', 'ALWAYS VISIBLE',
        'ALWAYS', 200, 200);


update core_class_attributes set tooltip = '<p>Enter a name for the Python class. See the package-field for more details.</p>' where core_class_id = (select id from core_classes where name = 'Packet') and name = 'className';

