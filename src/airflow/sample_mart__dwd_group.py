from datetime import (
    datetime,
    timedelta,
    time
)

from airflow.operators.email_operator import EmailOperator
from airflow.operators.sensors import ExternalTaskSensor
from airflow.contrib.sensors.dagrun_sensor import DagRunSensor
from airflow.operators.dummy_operator import DummyOperator
from airflow.utils.state import State
from airflow.contrib.hooks.ssh_hook import SSHHook
from airflow.contrib.operators.ssh_operator import SSHOperator

from airflow import DAG
from airflow.models import Variable

# Template: table_name: marker_config
marker_dependencies = {
    'sample_mart__ods_group': {
        'marker_name': 'sample_mart__ods_group',
        # and some more marker
    },
}

# create list of wait_task_id(s) based on dependencies dict
wait_task_list = []
for table_name, marker_config in marker_dependencies.items():
    wait_task_id='wait_for_{0}'.format(table_name)
    wait_task_list.append(wait_task_id)

# Alert msg template
ALERT_MESSAGE = """
@channel
[Alert]
System: ods
Environment: %s Env
Engineer on-call: Refer to duty list
Alert Message: {{task_id}} in {{dag_id}} %s.
"""


default_args = {
    'owner': 'long.vuduc',
    # general params #
    'start_date': days_ago(1),
    'local_macros': True,
    'depends_on_past': False,    # retry params #
    'retries': 3,
    'retry_delay': timedelta(minutes=3),
    # msg params #
    'email': 'vuduclong0309@gmail.com',
    'email_on_retry': True,
    'email_on_failure': True,
    # 'phone': ','.join(phone for (_,phone) in PIC_LIST),
    # 'sms_on_retry': True,
    # 'sms_on_failure': True,
    'msg_for_failure': ALERT_MESSAGE % (env, 'just failed'),
}

# * * * * * command to be executed
# - - - - -
# | | | | |
# | | | | ----- Day of week (0 - 7) (Sunday=0 or 7)
# | | | ------- Month (1 - 12)
# | | --------- Day of month (1 - 31)
# | ----------- Hour (0 - 23)
# ------------- Minute (0 - 59)

dag = DAG(
    dag_id='sample_mart__ods_group', # TODO: create a unique DAG id for this DAG "entry_task_active_user_{username_without_dot}"
    default_args=default_args,
    schedule_interval='0 * * * *',  # Run hourly at xx:00
    time_zone='Asia/Singapore',

    # output tables
    output='the table',  # TODO: insert your middle table name

    mm_on_sla_miss=True,
    msg_for_sla_miss=ALERT_MESSAGE % (env, 'is running longer than usual'),
    sla=timedelta(minutes='xx'),   # need to adjust sla based on DAG duration - current DE buffer is 0 but may change in future
    sla_exclude_task_ids=['start'] + wait_task_list, # exclude start task and upstream dependencies
)

# To group start of tasks
start = DummyOperator(
    task_id='start',
    dag=dag
)

# Dependecy set up
wait_upstream_ods = ExternalTaskSensor(
    task_id='wait_upstream_ods',
    soft_fail=False,
    retries=2,
    external_task_id='end',
    external_dag_id='sample_mart__ods_group',
    dag=dag)

wait_upstream_dim = ExternalTaskSensor(
    task_id='wait_upstream_dim',
    soft_fail=False,
    retries=2,
    external_task_id='end',
    external_dag_id='sample_mart__dim_group',
    dag=dag)

# Task to run ods_order
dwd_orders_item_item_sold_di = SHHOperator(
    task_id = 'dwd_orders_item_item_sold_di',
    hook = some_hook to maybe AWS,
    command = 'some command to run the dml sql',
)

email_success = EmailOperator(
    task_id='email_success',
    to=[PIC[0] for PIC in PIC_LIST] if PIC_LIST else '', # get emails from PIC list
    subject='%s Env {{ dag.dag_id }} Done' % env,
    html_content='%s Env {{ dag.dag_id }} Done on {{ ds }}' % env,
    dag=dag
)

# To group end of tasks
end = DummyOperator(
    task_id='end',
    dag=dag
)

## DAG set up
start >> wait_upstream_dim >> [dwd table list] >> email_success >> end
start >> wait_upstream_ods >> [dwd table list] >> email_success >> end
