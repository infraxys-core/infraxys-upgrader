update core_class_attributes set tooltip = '' where name = 'cronExpression' and core_class_id = (select id from core_classes where name = 'ActionSchedule');
