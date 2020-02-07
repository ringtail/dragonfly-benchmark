# dragonfly-benchmark
Dragonfly is an intelligent P2P based image and file distribution system. This repo contains a list of benchmark scripts. You can use the scripts to get the benchmark report and tuning dragonfly.

## Related Project 
<a href="https://github.com/ringtail/kubectl-pexec">kubectl-pexec</a>(kubectl-pexec is a kubectl plugin to exec commands in multi pods like pssh.)
<a href="https://github.com/aliyun/ossutil">ossutil</a>(A user friendly command line tool to access AliCloud OSS.)
## Run the benchmark 

#### 1. setup dragonfly supernode 
use the yaml 
```yaml 
apiVersion: apps/v1beta2 # for versions before 1.8.0 use apps/v1beta1
kind: Deployment
metadata:
  name: supernode
  labels:
    app: supernode
spec:
  replicas: 2
  selector:
    matchLabels:
      app: supernode
  template:
    metadata:
      labels:
        app: supernode
    spec:
      hostNetwork: true
      containers:
      - name: supernode
        image: registry.cn-zhangjiakou.aliyuncs.com/ringtail/supernode:1.0.0-tuning
        args:
        - '--max-bandwidth'
        - 6GB
        - '--up-limit'
        - '30'
        restart: always
        ports:
        - containerPort: 8081
        - containerPort: 8082
```
The args is very important. Pls check the internal bandwidth of the vm. To gain better tuning performance,`--max-bandwidth` could equals to the internal bandwidth of the vm. And `--up-limit` could be the value of bandwidth/200. 

#### 2. setup dragonfly preheat pod 
preheat is very useful. preheat can save at most 60% time cost in a large cluster.
```yaml 
apiVersion: apps/v1beta2 # for versions before 1.8.0 use apps/v1beta1
kind: Deployment
metadata:
  name: dragonfly-preheat
  labels:
    app: dragonfly-preheat
spec:
  replicas: 2
  selector:
    matchLabels:
      app: dragonfly-preheat
  template:
    metadata:
      labels:
        app: dragonfly-preheat
    spec:
      hostNetwork: true
      containers:
      - name: dragonfly-preheat
        image: registry.cn-zhangjiakou.aliyuncs.com/ringtail/dfclient:1.0.0-tuning
        restart: always
``` 

#### 3. setup dragonfly agent daemonset 
You can use `dfget` in the pod of agent
```yaml 
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: dragonfly-agent
  namespace: default
  labels:
    app:  dragonfly-agent
spec:
  selector:
    matchLabels:
      app:  dragonfly-agent
  template:
    metadata:
      labels:
        app:  dragonfly-agent
    spec:
      hostNetwork: true
      containers:
      - name:  dragonfly-agent
        image: registry.cn-zhangjiakou.aliyuncs.com/ringtail/dfclient:1.0.0-tuning 
```

#### 4. prepare environment 
1. create a oss bucket(dragonfly-benchmark) to store the test data with global read permission.
2. prepare the environments below. 
```$xslt
export endpoint=oss-cn-zhangjiakou.aliyuncs.com
export internalendpoint=oss-cn-zhangjiakou-internal.aliyuncs.com
export accessKeyId=your_ak_id
export accessKeySecret=your_ak_secret
export supernodes=nodeIp1,nodeIp2
```

#### 5. install kubectl-pexec and ossutil 
Pls follow the steps on github 
* https://github.com/ringtail/kubectl-pexec
* https://github.com/aliyun/ossutil

#### 6. run benchmark scripts 
```shell 
# export envs 
export endpoint=oss-cn-zhangjiakou.aliyuncs.com
export internalendpoint=oss-cn-zhangjiakou-internal.aliyuncs.com
export accessKeyId=your_ak_id
export accessKeySecret=your_ak_secret
export supernodes=nodeIp1,nodeIp2

# cd to folder 
cd tools 

# 3 means to run benchmark 3 times 
# dragonfly-benchmark is the bucket name 
# 51200 is the size of mock files 

./benchmark 3 dragonfly-benchmark 51200
```
shell output 
```shell 
--------------- benchmark No: 1 ---------------
51200+0 records in
51200+0 records out
52428800 bytes transferred in 0.346242 secs (151422437 bytes/sec)
Succeed: Total num: 1, size: 52,428,800. OK num: 1(upload 1 files).

9.232738(s) elapsed
download SUCCESS cost:1.093s length:52428800 reason:0
download SUCCESS cost:1.204s length:52428800 reason:0
All pods execution done in 1.861s


Start to fetch file from agent
download SUCCESS cost:0.897s length:52428800 reason:0
download SUCCESS cost:1.161s length:52428800 reason:0
download SUCCESS cost:1.170s length:52428800 reason:0
download SUCCESS cost:1.253s length:52428800 reason:0
download SUCCESS cost:1.644s length:52428800 reason:0
download SUCCESS cost:1.648s length:52428800 reason:0
download SUCCESS cost:1.706s length:52428800 reason:0
download SUCCESS cost:1.709s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.748s length:52428800 reason:0
download SUCCESS cost:0.696s length:52428800 reason:0
download SUCCESS cost:1.752s length:52428800 reason:0
download SUCCESS cost:0.747s length:52428800 reason:0
download SUCCESS cost:0.800s length:52428800 reason:0
download SUCCESS cost:1.756s length:52428800 reason:0
download SUCCESS cost:0.748s length:52428800 reason:0
download SUCCESS cost:0.767s length:52428800 reason:0
download SUCCESS cost:0.778s length:52428800 reason:0
download SUCCESS cost:1.840s length:52428800 reason:0
download SUCCESS cost:0.779s length:52428800 reason:0
download SUCCESS cost:0.768s length:52428800 reason:0
download SUCCESS cost:0.773s length:52428800 reason:0
download SUCCESS cost:1.920s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.776s length:52428800 reason:0
download SUCCESS cost:0.793s length:52428800 reason:0
download SUCCESS cost:0.767s length:52428800 reason:0
download SUCCESS cost:0.812s length:52428800 reason:0
download SUCCESS cost:1.191s length:52428800 reason:0
download SUCCESS cost:0.762s length:52428800 reason:0
download SUCCESS cost:1.340s length:52428800 reason:0
download SUCCESS cost:0.787s length:52428800 reason:0
download SUCCESS cost:0.893s length:52428800 reason:0
download SUCCESS cost:0.780s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.803s length:52428800 reason:0
download SUCCESS cost:0.820s length:52428800 reason:0
download SUCCESS cost:0.778s length:52428800 reason:0
download SUCCESS cost:0.740s length:52428800 reason:0
download SUCCESS cost:1.143s length:52428800 reason:0
download SUCCESS cost:0.968s length:52428800 reason:0
download SUCCESS cost:0.966s length:52428800 reason:0
download SUCCESS cost:0.965s length:52428800 reason:0
download SUCCESS cost:1.001s length:52428800 reason:0
download SUCCESS cost:1.001s length:52428800 reason:0
download SUCCESS cost:1.026s length:52428800 reason:0
download SUCCESS cost:1.112s length:52428800 reason:0
download SUCCESS cost:1.069s length:52428800 reason:0
download SUCCESS cost:1.185s length:52428800 reason:0
download SUCCESS cost:1.189s length:52428800 reason:0
download SUCCESS cost:1.243s length:52428800 reason:0
download SUCCESS cost:1.277s length:52428800 reason:0
download SUCCESS cost:1.142s length:52428800 reason:0
download SUCCESS cost:1.279s length:52428800 reason:0
download SUCCESS cost:1.312s length:52428800 reason:0
download SUCCESS cost:1.270s length:52428800 reason:0
download SUCCESS cost:1.248s length:52428800 reason:0
download SUCCESS cost:1.223s length:52428800 reason:0
download SUCCESS cost:1.240s length:52428800 reason:0
download SUCCESS cost:1.155s length:52428800 reason:0
download SUCCESS cost:1.283s length:52428800 reason:0
download SUCCESS cost:1.330s length:52428800 reason:0
download SUCCESS cost:1.195s length:52428800 reason:0
download SUCCESS cost:1.335s length:52428800 reason:0
download SUCCESS cost:1.263s length:52428800 reason:0
download SUCCESS cost:1.376s length:52428800 reason:0
download SUCCESS cost:1.399s length:52428800 reason:0
download SUCCESS cost:1.619s length:52428800 reason:0
download SUCCESS cost:1.760s length:52428800 reason:0
download SUCCESS cost:0.813s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.767s length:52428800 reason:0
download SUCCESS cost:0.810s length:52428800 reason:0
download SUCCESS cost:1.837s length:52428800 reason:0
download SUCCESS cost:0.752s length:52428800 reason:0
download SUCCESS cost:1.902s length:52428800 reason:0
download SUCCESS cost:0.713s length:52428800 reason:0
download SUCCESS cost:0.705s length:52428800 reason:0
download SUCCESS cost:1.846s length:52428800 reason:0
download SUCCESS cost:0.763s length:52428800 reason:0
download SUCCESS cost:0.707s length:52428800 reason:0
download SUCCESS cost:0.882s length:52428800 reason:0
download SUCCESS cost:0.694s length:52428800 reason:0
download SUCCESS cost:0.762s length:52428800 reason:0
download SUCCESS cost:0.734s length:52428800 reason:0
download SUCCESS cost:0.716s length:52428800 reason:0
download SUCCESS cost:0.726s length:52428800 reason:0
download SUCCESS cost:2.011s length:52428800 reason:0
download SUCCESS cost:0.767s length:52428800 reason:0
download SUCCESS cost:0.719s length:52428800 reason:0
download SUCCESS cost:0.794s length:52428800 reason:0
download SUCCESS cost:0.795s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.719s length:52428800 reason:0
download SUCCESS cost:0.753s length:52428800 reason:0
download SUCCESS cost:0.810s length:52428800 reason:0
download SUCCESS cost:0.800s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.774s length:52428800 reason:0
download SUCCESS cost:0.758s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:1.967s length:52428800 reason:0
download SUCCESS cost:0.778s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.761s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:0.777s length:52428800 reason:0
download SUCCESS cost:0.768s length:52428800 reason:0
download SUCCESS cost:0.844s length:52428800 reason:0
download SUCCESS cost:0.797s length:52428800 reason:0
download SUCCESS cost:0.805s length:52428800 reason:0
download SUCCESS cost:1.143s length:52428800 reason:0
download SUCCESS cost:0.788s length:52428800 reason:0
download SUCCESS cost:0.748s length:52428800 reason:0
download SUCCESS cost:0.776s length:52428800 reason:0
download SUCCESS cost:0.787s length:52428800 reason:0
download SUCCESS cost:0.812s length:52428800 reason:0
download SUCCESS cost:0.801s length:52428800 reason:0
download SUCCESS cost:2.072s length:52428800 reason:0
download SUCCESS cost:0.781s length:52428800 reason:0
download SUCCESS cost:2.095s length:52428800 reason:0
download SUCCESS cost:2.085s length:52428800 reason:0
download SUCCESS cost:0.808s length:52428800 reason:0
download SUCCESS cost:0.803s length:52428800 reason:0
download SUCCESS cost:0.818s length:52428800 reason:0
download SUCCESS cost:0.840s length:52428800 reason:0
download SUCCESS cost:2.114s length:52428800 reason:0
download SUCCESS cost:0.744s length:52428800 reason:0
download SUCCESS cost:2.137s length:52428800 reason:0
download SUCCESS cost:1.232s length:52428800 reason:0
download SUCCESS cost:0.777s length:52428800 reason:0
download SUCCESS cost:0.768s length:52428800 reason:0
download SUCCESS cost:2.041s length:52428800 reason:0
download SUCCESS cost:0.803s length:52428800 reason:0
download SUCCESS cost:0.803s length:52428800 reason:0
download SUCCESS cost:2.252s length:52428800 reason:0
download SUCCESS cost:2.219s length:52428800 reason:0
download SUCCESS cost:2.220s length:52428800 reason:0
download SUCCESS cost:2.262s length:52428800 reason:0
download SUCCESS cost:2.254s length:52428800 reason:0
download SUCCESS cost:2.280s length:52428800 reason:0
download SUCCESS cost:0.768s length:52428800 reason:0
download SUCCESS cost:2.228s length:52428800 reason:0
download SUCCESS cost:2.359s length:52428800 reason:0
download SUCCESS cost:2.304s length:52428800 reason:0
download SUCCESS cost:0.808s length:52428800 reason:0
download SUCCESS cost:0.803s length:52428800 reason:0
download SUCCESS cost:2.412s length:52428800 reason:0
download SUCCESS cost:1.202s length:52428800 reason:0
download SUCCESS cost:0.768s length:52428800 reason:0
download SUCCESS cost:2.512s length:52428800 reason:0
download SUCCESS cost:0.792s length:52428800 reason:0
download SUCCESS cost:2.584s length:52428800 reason:0
download SUCCESS cost:2.668s length:52428800 reason:0
download SUCCESS cost:0.769s length:52428800 reason:0
download SUCCESS cost:0.707s length:52428800 reason:0
download SUCCESS cost:1.271s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:2.656s length:52428800 reason:0
download SUCCESS cost:2.609s length:52428800 reason:0
download SUCCESS cost:0.794s length:52428800 reason:0
download SUCCESS cost:0.804s length:52428800 reason:0
download SUCCESS cost:0.768s length:52428800 reason:0
download SUCCESS cost:0.761s length:52428800 reason:0
download SUCCESS cost:0.767s length:52428800 reason:0
download SUCCESS cost:0.692s length:52428800 reason:0
download SUCCESS cost:0.795s length:52428800 reason:0
download SUCCESS cost:0.767s length:52428800 reason:0
download SUCCESS cost:0.709s length:52428800 reason:0
download SUCCESS cost:0.798s length:52428800 reason:0
download SUCCESS cost:0.823s length:52428800 reason:0
download SUCCESS cost:0.770s length:52428800 reason:0
download SUCCESS cost:0.799s length:52428800 reason:0
download SUCCESS cost:0.780s length:52428800 reason:0
download SUCCESS cost:0.727s length:52428800 reason:0
download SUCCESS cost:0.698s length:52428800 reason:0
download SUCCESS cost:0.798s length:52428800 reason:0
download SUCCESS cost:0.799s length:52428800 reason:0
download SUCCESS cost:0.750s length:52428800 reason:0
download SUCCESS cost:0.709s length:52428800 reason:0
download SUCCESS cost:0.769s length:52428800 reason:0
download SUCCESS cost:0.663s length:52428800 reason:0
download SUCCESS cost:0.751s length:52428800 reason:0
download SUCCESS cost:0.663s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.698s length:52428800 reason:0
download SUCCESS cost:0.762s length:52428800 reason:0
download SUCCESS cost:0.740s length:52428800 reason:0
download SUCCESS cost:0.788s length:52428800 reason:0
download SUCCESS cost:0.796s length:52428800 reason:0
download SUCCESS cost:0.783s length:52428800 reason:0
download SUCCESS cost:0.787s length:52428800 reason:0
download SUCCESS cost:0.705s length:52428800 reason:0
download SUCCESS cost:0.772s length:52428800 reason:0
download SUCCESS cost:0.796s length:52428800 reason:0
download SUCCESS cost:0.799s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.753s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:0.767s length:52428800 reason:0
download SUCCESS cost:0.800s length:52428800 reason:0
download SUCCESS cost:0.753s length:52428800 reason:0
download SUCCESS cost:0.786s length:52428800 reason:0
download SUCCESS cost:0.805s length:52428800 reason:0
download SUCCESS cost:0.756s length:52428800 reason:0
download SUCCESS cost:0.793s length:52428800 reason:0
download SUCCESS cost:0.793s length:52428800 reason:0
download SUCCESS cost:0.751s length:52428800 reason:0
download SUCCESS cost:0.762s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:0.770s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:0.771s length:52428800 reason:0
download SUCCESS cost:0.705s length:52428800 reason:0
download SUCCESS cost:0.815s length:52428800 reason:0
download SUCCESS cost:0.804s length:52428800 reason:0
download SUCCESS cost:0.789s length:52428800 reason:0
download SUCCESS cost:0.810s length:52428800 reason:0
download SUCCESS cost:0.813s length:52428800 reason:0
download SUCCESS cost:0.803s length:52428800 reason:0
download SUCCESS cost:0.817s length:52428800 reason:0
download SUCCESS cost:0.763s length:52428800 reason:0
download SUCCESS cost:0.812s length:52428800 reason:0
download SUCCESS cost:0.808s length:52428800 reason:0
download SUCCESS cost:0.731s length:52428800 reason:0
download SUCCESS cost:0.796s length:52428800 reason:0
download SUCCESS cost:0.824s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.806s length:52428800 reason:0
download SUCCESS cost:1.221s length:52428800 reason:0
download SUCCESS cost:0.812s length:52428800 reason:0
download SUCCESS cost:0.803s length:52428800 reason:0
download SUCCESS cost:0.772s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:1.173s length:52428800 reason:0
download SUCCESS cost:0.781s length:52428800 reason:0
download SUCCESS cost:0.665s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.720s length:52428800 reason:0
download SUCCESS cost:0.762s length:52428800 reason:0
download SUCCESS cost:0.698s length:52428800 reason:0
download SUCCESS cost:0.787s length:52428800 reason:0
download SUCCESS cost:1.394s length:52428800 reason:0
download SUCCESS cost:0.811s length:52428800 reason:0
download SUCCESS cost:0.664s length:52428800 reason:0
download SUCCESS cost:0.741s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.784s length:52428800 reason:0
download SUCCESS cost:0.754s length:52428800 reason:0
download SUCCESS cost:0.707s length:52428800 reason:0
download SUCCESS cost:0.809s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:0.771s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:0.787s length:52428800 reason:0
download SUCCESS cost:0.762s length:52428800 reason:0
download SUCCESS cost:0.763s length:52428800 reason:0
download SUCCESS cost:0.769s length:52428800 reason:0
download SUCCESS cost:0.811s length:52428800 reason:0
download SUCCESS cost:0.767s length:52428800 reason:0
download SUCCESS cost:0.800s length:52428800 reason:0
download SUCCESS cost:0.788s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.799s length:52428800 reason:0
download SUCCESS cost:0.804s length:52428800 reason:0
download SUCCESS cost:0.839s length:52428800 reason:0
download SUCCESS cost:0.797s length:52428800 reason:0
download SUCCESS cost:0.823s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.775s length:52428800 reason:0
download SUCCESS cost:0.812s length:52428800 reason:0
download SUCCESS cost:0.786s length:52428800 reason:0
download SUCCESS cost:0.811s length:52428800 reason:0
download SUCCESS cost:0.806s length:52428800 reason:0
download SUCCESS cost:0.791s length:52428800 reason:0
download SUCCESS cost:0.807s length:52428800 reason:0
download SUCCESS cost:0.811s length:52428800 reason:0
download SUCCESS cost:0.832s length:52428800 reason:0
download SUCCESS cost:0.776s length:52428800 reason:0
download SUCCESS cost:0.705s length:52428800 reason:0
download SUCCESS cost:0.726s length:52428800 reason:0
download SUCCESS cost:1.361s length:52428800 reason:0
download SUCCESS cost:0.808s length:52428800 reason:0
download SUCCESS cost:0.737s length:52428800 reason:0
download SUCCESS cost:0.711s length:52428800 reason:0
download SUCCESS cost:0.755s length:52428800 reason:0
download SUCCESS cost:0.763s length:52428800 reason:0
download SUCCESS cost:0.755s length:52428800 reason:0
download SUCCESS cost:0.767s length:52428800 reason:0
download SUCCESS cost:0.760s length:52428800 reason:0
download SUCCESS cost:0.763s length:52428800 reason:0
download SUCCESS cost:0.756s length:52428800 reason:0
download SUCCESS cost:0.789s length:52428800 reason:0
download SUCCESS cost:0.773s length:52428800 reason:0
download SUCCESS cost:0.807s length:52428800 reason:0
download SUCCESS cost:0.671s length:52428800 reason:0
download SUCCESS cost:0.809s length:52428800 reason:0
download SUCCESS cost:0.780s length:52428800 reason:0
download SUCCESS cost:0.676s length:52428800 reason:0
download SUCCESS cost:0.806s length:52428800 reason:0
download SUCCESS cost:0.801s length:52428800 reason:0
download SUCCESS cost:0.802s length:52428800 reason:0
download SUCCESS cost:0.707s length:52428800 reason:0
download SUCCESS cost:0.809s length:52428800 reason:0
download SUCCESS cost:0.770s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.763s length:52428800 reason:0
download SUCCESS cost:0.813s length:52428800 reason:0
download SUCCESS cost:0.773s length:52428800 reason:0
download SUCCESS cost:1.174s length:52428800 reason:0
download SUCCESS cost:1.239s length:52428800 reason:0
download SUCCESS cost:1.107s length:52428800 reason:0
download SUCCESS cost:0.866s length:52428800 reason:0
download SUCCESS cost:1.057s length:52428800 reason:0
download SUCCESS cost:1.094s length:52428800 reason:0
download SUCCESS cost:1.219s length:52428800 reason:0
download SUCCESS cost:1.099s length:52428800 reason:0
download SUCCESS cost:1.006s length:52428800 reason:0
download SUCCESS cost:1.328s length:52428800 reason:0
download SUCCESS cost:1.111s length:52428800 reason:0
download SUCCESS cost:0.966s length:52428800 reason:0
download SUCCESS cost:1.063s length:52428800 reason:0
download SUCCESS cost:1.057s length:52428800 reason:0
download SUCCESS cost:1.054s length:52428800 reason:0
download SUCCESS cost:0.936s length:52428800 reason:0
download SUCCESS cost:1.093s length:52428800 reason:0
download SUCCESS cost:1.142s length:52428800 reason:0
download SUCCESS cost:0.986s length:52428800 reason:0
download SUCCESS cost:1.045s length:52428800 reason:0
download SUCCESS cost:1.087s length:52428800 reason:0
download SUCCESS cost:1.138s length:52428800 reason:0
download SUCCESS cost:0.934s length:52428800 reason:0
download SUCCESS cost:1.135s length:52428800 reason:0
download SUCCESS cost:1.128s length:52428800 reason:0
download SUCCESS cost:1.134s length:52428800 reason:0
download SUCCESS cost:1.128s length:52428800 reason:0
download SUCCESS cost:1.129s length:52428800 reason:0
download SUCCESS cost:1.322s length:52428800 reason:0
download SUCCESS cost:0.796s length:52428800 reason:0
download SUCCESS cost:0.794s length:52428800 reason:0
download SUCCESS cost:0.783s length:52428800 reason:0
download SUCCESS cost:1.597s length:52428800 reason:0
download SUCCESS cost:0.805s length:52428800 reason:0
download SUCCESS cost:1.484s length:52428800 reason:0
download SUCCESS cost:1.618s length:52428800 reason:0
download SUCCESS cost:0.811s length:52428800 reason:0
download SUCCESS cost:1.457s length:52428800 reason:0
download SUCCESS cost:0.788s length:52428800 reason:0
download SUCCESS cost:0.697s length:52428800 reason:0
download SUCCESS cost:0.706s length:52428800 reason:0
download SUCCESS cost:0.693s length:52428800 reason:0
download SUCCESS cost:0.708s length:52428800 reason:0
download SUCCESS cost:0.724s length:52428800 reason:0
download SUCCESS cost:0.717s length:52428800 reason:0
download SUCCESS cost:0.705s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:1.678s length:52428800 reason:0
download SUCCESS cost:0.755s length:52428800 reason:0
download SUCCESS cost:0.743s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:0.747s length:52428800 reason:0
download SUCCESS cost:0.783s length:52428800 reason:0
download SUCCESS cost:0.798s length:52428800 reason:0
download SUCCESS cost:0.831s length:52428800 reason:0
download SUCCESS cost:0.807s length:52428800 reason:0
download SUCCESS cost:0.799s length:52428800 reason:0
download SUCCESS cost:0.794s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:0.798s length:52428800 reason:0
download SUCCESS cost:2.000s length:52428800 reason:0
download SUCCESS cost:0.805s length:52428800 reason:0
download SUCCESS cost:2.188s length:52428800 reason:0
download SUCCESS cost:0.664s length:52428800 reason:0
download SUCCESS cost:0.782s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:0.810s length:52428800 reason:0
download SUCCESS cost:1.242s length:52428800 reason:0
download SUCCESS cost:1.303s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.763s length:52428800 reason:0
download SUCCESS cost:0.803s length:52428800 reason:0
download SUCCESS cost:0.804s length:52428800 reason:0
download SUCCESS cost:0.767s length:52428800 reason:0
download SUCCESS cost:1.392s length:52428800 reason:0
download SUCCESS cost:0.791s length:52428800 reason:0
download SUCCESS cost:1.360s length:52428800 reason:0
download SUCCESS cost:0.784s length:52428800 reason:0
download SUCCESS cost:0.781s length:52428800 reason:0
download SUCCESS cost:1.434s length:52428800 reason:0
download SUCCESS cost:0.814s length:52428800 reason:0
download SUCCESS cost:0.799s length:52428800 reason:0
download SUCCESS cost:1.446s length:52428800 reason:0
download SUCCESS cost:0.887s length:52428800 reason:0
download SUCCESS cost:0.726s length:52428800 reason:0
download SUCCESS cost:1.368s length:52428800 reason:0
download SUCCESS cost:1.551s length:52428800 reason:0
download SUCCESS cost:1.560s length:52428800 reason:0
download SUCCESS cost:1.579s length:52428800 reason:0
download SUCCESS cost:1.672s length:52428800 reason:0
download SUCCESS cost:1.660s length:52428800 reason:0
download SUCCESS cost:1.719s length:52428800 reason:0
download SUCCESS cost:0.666s length:52428800 reason:0
download SUCCESS cost:1.749s length:52428800 reason:0
download SUCCESS cost:1.733s length:52428800 reason:0
download SUCCESS cost:0.694s length:52428800 reason:0
download SUCCESS cost:1.778s length:52428800 reason:0
download SUCCESS cost:0.712s length:52428800 reason:0
download SUCCESS cost:0.757s length:52428800 reason:0
download SUCCESS cost:0.682s length:52428800 reason:0
download SUCCESS cost:0.762s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:0.756s length:52428800 reason:0
download SUCCESS cost:0.699s length:52428800 reason:0
download SUCCESS cost:1.836s length:52428800 reason:0
download SUCCESS cost:0.796s length:52428800 reason:0
download SUCCESS cost:0.775s length:52428800 reason:0
download SUCCESS cost:1.785s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:0.765s length:52428800 reason:0
download SUCCESS cost:1.884s length:52428800 reason:0
download SUCCESS cost:0.798s length:52428800 reason:0
download SUCCESS cost:1.861s length:52428800 reason:0
download SUCCESS cost:0.762s length:52428800 reason:0
download SUCCESS cost:0.805s length:52428800 reason:0
download SUCCESS cost:0.813s length:52428800 reason:0
download SUCCESS cost:0.799s length:52428800 reason:0
download SUCCESS cost:0.762s length:52428800 reason:0
download SUCCESS cost:0.771s length:52428800 reason:0
download SUCCESS cost:0.795s length:52428800 reason:0
download SUCCESS cost:0.768s length:52428800 reason:0
download SUCCESS cost:1.294s length:52428800 reason:0
download SUCCESS cost:0.768s length:52428800 reason:0
download SUCCESS cost:0.762s length:52428800 reason:0
download SUCCESS cost:0.766s length:52428800 reason:0
download SUCCESS cost:1.888s length:52428800 reason:0
download SUCCESS cost:0.801s length:52428800 reason:0
download SUCCESS cost:0.779s length:52428800 reason:0
download SUCCESS cost:0.810s length:52428800 reason:0
download SUCCESS cost:0.815s length:52428800 reason:0
download SUCCESS cost:1.925s length:52428800 reason:0
download SUCCESS cost:0.816s length:52428800 reason:0
download SUCCESS cost:1.922s length:52428800 reason:0
download SUCCESS cost:1.945s length:52428800 reason:0
download SUCCESS cost:0.664s length:52428800 reason:0
download SUCCESS cost:1.944s length:52428800 reason:0
download SUCCESS cost:0.921s length:52428800 reason:0
download SUCCESS cost:0.701s length:52428800 reason:0
download SUCCESS cost:2.051s length:52428800 reason:0
download SUCCESS cost:0.768s length:52428800 reason:0
download SUCCESS cost:0.752s length:52428800 reason:0
download SUCCESS cost:2.093s length:52428800 reason:0
download SUCCESS cost:0.793s length:52428800 reason:0
download SUCCESS cost:0.788s length:52428800 reason:0
download SUCCESS cost:0.773s length:52428800 reason:0
download SUCCESS cost:2.100s length:52428800 reason:0
download SUCCESS cost:0.775s length:52428800 reason:0
download SUCCESS cost:0.787s length:52428800 reason:0
download SUCCESS cost:0.792s length:52428800 reason:0
download SUCCESS cost:0.763s length:52428800 reason:0
download SUCCESS cost:0.826s length:52428800 reason:0
download SUCCESS cost:2.126s length:52428800 reason:0
download SUCCESS cost:0.805s length:52428800 reason:0
download SUCCESS cost:0.759s length:52428800 reason:0
download SUCCESS cost:0.817s length:52428800 reason:0
download SUCCESS cost:0.664s length:52428800 reason:0
download SUCCESS cost:0.712s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.764s length:52428800 reason:0
download SUCCESS cost:0.738s length:52428800 reason:0
download SUCCESS cost:0.781s length:52428800 reason:0
download SUCCESS cost:0.762s length:52428800 reason:0
download SUCCESS cost:0.767s length:52428800 reason:0
download SUCCESS cost:0.778s length:52428800 reason:0
download SUCCESS cost:0.770s length:52428800 reason:0
download SUCCESS cost:0.783s length:52428800 reason:0
download SUCCESS cost:0.775s length:52428800 reason:0
download SUCCESS cost:0.811s length:52428800 reason:0
download SUCCESS cost:0.791s length:52428800 reason:0
download SUCCESS cost:0.800s length:52428800 reason:0
download SUCCESS cost:0.794s length:52428800 reason:0
download SUCCESS cost:0.798s length:52428800 reason:0
download SUCCESS cost:0.797s length:52428800 reason:0
download SUCCESS cost:0.774s length:52428800 reason:0
download SUCCESS cost:0.806s length:52428800 reason:0
download SUCCESS cost:0.829s length:52428800 reason:0
download SUCCESS cost:1.260s length:52428800 reason:0
download SUCCESS cost:0.779s length:52428800 reason:0
download SUCCESS cost:1.245s length:52428800 reason:0
download SUCCESS cost:0.812s length:52428800 reason:0
download SUCCESS cost:2.136s length:52428800 reason:0
download SUCCESS cost:0.872s length:52428800 reason:0
download SUCCESS cost:1.308s length:52428800 reason:0
download SUCCESS cost:1.293s length:52428800 reason:0
download SUCCESS cost:1.225s length:52428800 reason:0
download SUCCESS cost:1.296s length:52428800 reason:0
download SUCCESS cost:1.335s length:52428800 reason:0
download SUCCESS cost:1.376s length:52428800 reason:0
download SUCCESS cost:1.773s length:52428800 reason:0
download SUCCESS cost:1.909s length:52428800 reason:0
All pods execution done in 11.997s


Done
Clean up files
Succeed: Total 1 objects. Removed 1 objects.

0.214689(s) elapsed
All pods execution done in 15.902s


--------------- benchmark Done ---------------
```

## License
<a href="LICENSE">MIT</a>