alter table core_classes modify POPUP_WIDTH varchar(10) null;
alter table core_classes modify POPUP_HEIGHT varchar(10) null;

update infraxys.core_classes set POPUP_WIDTH = concat(POPUP_WIDTH, 'px') where POPUP_WIDTH != '0' and POPUP_WIDTH not like '%px' and name != 'Instance';
update infraxys.core_classes set POPUP_HEIGHT = concat(POPUP_HEIGHT, 'px') where POPUP_HEIGHT != '0' and POPUP_WIDTH not like '%px' and name != 'Instance';
update infraxys.core_classes set POPUP_HEIGHT = '100%', POPUP_WIDTH = '100%' where name = 'Instance';

alter table action_logs add column if not exists action_run_guid varchar(256);
create index if not exists action_logs_wf_run_guid
    on action_logs (action_run_guid, workflow_run_guid);

update core_class_attributes set LIST_OF_VALUES = 'java.lang.Boolean=Checkbox,java.util.Date=Date,java.lang.Long=Number,byte[]=Text (multiple lines),java.lang.String=Text (one line)'
    where name = 'typeClassName' and CORE_CLASS_ID = (select id from core_classes where name = 'CoreClassAttribute');
