### Installting Rally
```
# sudo yum -y groupinstall 'Development Tools'
# sudo yum -y libffi-devel python-devel openssl-devel gmp-devel libxml2-devel libxslt-devel postgresql-devel python-pip
# git clone https://github.com/openstack/rally.git   
# cd rally/etc/rally    
# ./install_rally.sh   
 ```
### Running from VirualEnv
`. rally/bin/activate`

### Create a Deployment
`# rally deployment create --fromenv --name=existing`  
** You can create one from a file **    
`# rally deployment create --file=existing.json --name=existing`  

`# source ~/.rally/openrc`  
`# sudo rally deployment list`  
\+--------------------------------------+----------------------------+------+------------------+--------+  
\| uuid                                 | created_at                 | name | status           | active |  
\+--------------------------------------+----------------------------+------+------------------+--------+  
\| 25087278-2a07-46f2-9b19-9b3c19d87dfe | 2015-06-10 12:54:24.450250 | dev1 | deploy->finished | *      |  
\+--------------------------------------+----------------------------+------+------------------+--------+  
### Download and run a scenario
##### boot-runcommand-delete scenario
 
`# rally -v task start rally/samples/tasks/scenarios/vm/boot-runcommand-delete.yaml`  
` # rally task report defcf0b6-d2d7-4248-beeb-27036b0644fd --out output.html`

The code for this scenario is at https://github.com/openstack/rally/blob/master/rally/plugins/openstack/scenarios/vm/vmtasks.py

### Show info of a scenario
To show a description of the test  
`# rally info find boot-runcommand-delete`  

### Runner
Looking at the boot-runcommand-delete YAML file we can see that there is a runner object  
      
      runner:
        type: "constant"
        times: 10
        concurrency: 2

Here we see that the type of the runner is constant , it will be run 10 times ,2 

There are four types of runner:  
1. *constant*  for creating a constant load by running the scenario for a fixed number of times, possibly in parallel (that's controlled by the "concurrency" parameter).  
2. *constant_for_duration* that works exactly as constant, but runs the benchmark scenario until a specified number of seconds elapses ("duration" parameter).  
3. *periodic*  which executes benchmark scenarios with intervals between two consecutive runs, specified in the "period" field in seconds.  
4. *serial* which is very useful to test new scenarios since it just runs the benchmark scenario for a fixed number of times in a single thread.  

### Quotas
   You need to think about the quotas and configure it according to your test

### Runnign script inside a test

### SLA
   You can configure the failure rate
