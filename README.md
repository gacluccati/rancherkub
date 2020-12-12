# ------------------------------------------------------------

# *** INSTALL INITIAL INFRASTRUCTURE : EC2 INSTANCES ; DOCKER , KUBERNETES (kubctl) and RANCHER

#
# ANSIBLE
#

#- Just need to run wrapped script to prepare inventory file (clean) and run Ansible playbook to create the initial infrastructure : -( inventory file hosts will be filled with EC2 IPs in create role )

#- playbook roles :

#- create = provising EC2 instances : 1 Rancher servers, 3 Kubernetes servers ( to be used as cluster )
#- domain = create Zone DNS < your domain > and all needed records to run Rancher and ALL apps using DNS ( Ex: rancher.< your domain > , traefik.rancher.< your domain >, ... )
#- setup  = install all needed packages ( docker, kubernetes, rancher ) and prepare servers to receive further configuration described below

#RUN:

./ansible.sh

#- ONCE EC2 instances and Docker ARE INSTALLED by Ansible, and Rancher is installed as container by Docker also by Ansible, all next infrastructure is set from Rancher, kubectl CLI and apps GUIs

# ------------------------------------------------------------

# *** CREATE KUBERNETE CLUSTER

#
# RANCHER ( http://rancher.< your domain > )
#

# 1) CREATE cluster ( suggested name = rancherkub ) in Global area, by click on 'Add Cluster' button.
#- IMPORTANT: during custom cluster creation, on Advanced Option, click on 'Disabled' on Nginx Ingress
#- On this solution we will use Traefik ingress

# 2) EXTRACT docker command to create kubernetes cluster
#- RUN in each k8s server changing var NODE_NAME ( k8s-1, k8s-2, k8s-3 )

#EX:

NODE_NAME=k8s-1

sudo docker run -d --privileged --restart=unless-stopped --net=host -v /etc/kubernetes:/etc/kubernetes -v /var/run:/var/run rancher/rancher-agent:v2.4.3 --server https://rancher.< your domain > --token gzc4ft52g8rqx6f47vhtkfdzzvh25fqvtgcszqqnvcjr5j4xzc2zls --ca-checksum 38739db300042ff4623b88d7bc535f93052aa4eb97a3990f0b7119eca699c05a --etcd --controlplane --worker --node-name ${NODE_NAME}

# 3) CLICK ON 'Kubeconfig File' button, once you clicked on cluster dashboard you generated on step 1, to generate kubectl config and install it on Rancher linux server ( ~/.kube/config )

#EX:

apiVersion: v1
kind: Config
clusters:
- name: "rancherkub"
  cluster:
    server: "https://rancher.< your domain >/k8s/clusters/c-prxbd"
    certificate-authority-data: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUJpVENDQ\
      VM2Z0F3SUJBZ0lCQURBS0JnZ3Foa2pPUFFRREFqQTdNUnd3R2dZRFZRUUtFeE5rZVc1aGJXbGoKY\
      kdsemRHVnVaWEl0YjNKbk1Sc3dHUVlEVlFRREV4SmtlVzVoYldsamJHbHpkR1Z1WlhJdFkyRXdIa\
      GNOTWpBeApNakE1TVRjeU5qTTBXaGNOTXpBeE1qQTNNVGN5TmpNMFdqQTdNUnd3R2dZRFZRUUtFe\
      E5rZVc1aGJXbGpiR2x6CmRHVnVaWEl0YjNKbk1Sc3dHUVlEVlFRREV4SmtlVzVoYldsamJHbHpkR\
      1Z1WlhJdFkyRXdXVEFUQmdjcWhrak8KUFFJQkJnZ3Foa2pPUFFNQkJ3TkNBQVFKQWEyQzRKRWZub\
      DRKMHZWdUlxL1I4aDI2Qk1jT1VkalFWOWdRVDc5UQprOHhlbjdUVkdPcDlUYThETVJDcWZIQjZne\
      HR0SHk1SlptRUxEYzRxQUVuRW95TXdJVEFPQmdOVkhROEJBZjhFCkJBTUNBcVF3RHdZRFZSMFRBU\
      UgvQkFVd0F3RUIvekFLQmdncWhrak9QUVFEQWdOSkFEQkdBaUVBd0M3aDViUEEKc0Zrd3dRL0xsO\
      GdPUzFWVFIrRXlwMFN4Q3R5ZFBvc3o1UDhDSVFDNXNBSXBwcmhBUVZrTnBFYmxZVWt4U3FZTword\
      XRQRXlvMmErL0RrRVRvSlE9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0t"
- name: "rancherkub-k8s-1"
  cluster:
    server: "https://172.31.13.128:6443"
    certificate-authority-data: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN3akNDQ\
      WFxZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFTTVJBd0RnWURWUVFERXdkcmRXSmwKT\
      FdOaE1CNFhEVEl3TVRJd09USXdNemt4TkZvWERUTXdNVEl3TnpJd016a3hORm93RWpFUU1BNEdBM\
      VVFQXhNSAphM1ZpWlMxallUQ0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ\
      0VCQUxJNENnN0VCdUJ2CndBbDl5MDVNTUVDZGdWZVR4V0dyZGFTY09BYTc1SERLRFpaTk5QczhWM\
      VBJZW5mWGtNRk1iK3J1Y05SSit0RjcKL0EwaStNd1FzZ1ByZ2cvb2ErM2lrcHlhQmRBNlVqYUhZR\
      zF4TldjTkI1dXdBZWIrUHVCR3NBblE0QmxDeXlvOAorOHh4MVpJL01IK2tBaFEyMnV2YmJjaktic\
      WJzY09mTWowSWxwamdrY3JDTVJuc3pjL24zV0pJR2NwWEhSU0lKCmhNcEhvaEZHdzN5dVpGQTlyR\
      GwwaTlGOW4wUk1yS2Vud20yOVozTE8yaFR2MVBTSXJJQTVieXl3T2V6Y2Mxc28KU3ptOVB5bDZ3R\
      HBzYnp2Vm5HV212WHNidEpDRS83Y3NOZkRyQmpCZ0RVRjJHeEhmbERIb3lzWjJwbjZnU1ZhQQpIT\
      3lmK0FRMzdSVUNBd0VBQWFNak1DRXdEZ1lEVlIwUEFRSC9CQVFEQWdLa01BOEdBMVVkRXdFQi93U\
      UZNQU1CCkFmOHdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSkZBRUtxdkVXaCtNLzdEOUhITjk0N\
      HlPRk5UakMveU1UeHEKbG9adjdzWElCOFVwMEJtNUJBdFVmeG1aN3ZsRHFjT2QwU0E1V0VEbFdLW\
      kNVZXNjeU9FQlJnanZCK0lINWowWgptQnlNeFFVZWJzVmlzaUk3SENQWmhFei9pRWI2OHJpdm8yV\
      khRU3ZEY1hiYkFFeVlkTHZwL2RiTEZlOUs0QVJoCmMvSmpmV2VjOUV4RnhvMVhGWUlmQUZyd3IzY\
      zV0Y0N3M0hqUytkS2lXaGxSTnEwV1lhS2lBMU9LQ2h4SVAxSGcKZ2lhZFNMd1Jvb3JpN3FQS1kzQ\
      k5XMDIwNmNvV3VmLzlLbndhbmx1UkQza1ZVY1lXY0dRdTVoZ051WTdzdFBOZwo2c1l6M1RGREhMO\
      UhUbG9pKytXdFVMcjVsWEw1YkFxRzY3MnBGR2s1SUJXd1dVU2IwYjg9Ci0tLS0tRU5EIENFUlRJR\
      klDQVRFLS0tLS0K"
- name: "rancherkub-k8s-3"
  cluster:
    server: "https://172.31.10.17:6443"
    certificate-authority-data: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN3akNDQ\
      WFxZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFTTVJBd0RnWURWUVFERXdkcmRXSmwKT\
      FdOaE1CNFhEVEl3TVRJd09USXdNemt4TkZvWERUTXdNVEl3TnpJd016a3hORm93RWpFUU1BNEdBM\
      VVFQXhNSAphM1ZpWlMxallUQ0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ\
      0VCQUxJNENnN0VCdUJ2CndBbDl5MDVNTUVDZGdWZVR4V0dyZGFTY09BYTc1SERLRFpaTk5QczhWM\
      VBJZW5mWGtNRk1iK3J1Y05SSit0RjcKL0EwaStNd1FzZ1ByZ2cvb2ErM2lrcHlhQmRBNlVqYUhZR\
      zF4TldjTkI1dXdBZWIrUHVCR3NBblE0QmxDeXlvOAorOHh4MVpJL01IK2tBaFEyMnV2YmJjaktic\
      WJzY09mTWowSWxwamdrY3JDTVJuc3pjL24zV0pJR2NwWEhSU0lKCmhNcEhvaEZHdzN5dVpGQTlyR\
      GwwaTlGOW4wUk1yS2Vud20yOVozTE8yaFR2MVBTSXJJQTVieXl3T2V6Y2Mxc28KU3ptOVB5bDZ3R\
      HBzYnp2Vm5HV212WHNidEpDRS83Y3NOZkRyQmpCZ0RVRjJHeEhmbERIb3lzWjJwbjZnU1ZhQQpIT\
      3lmK0FRMzdSVUNBd0VBQWFNak1DRXdEZ1lEVlIwUEFRSC9CQVFEQWdLa01BOEdBMVVkRXdFQi93U\
      UZNQU1CCkFmOHdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSkZBRUtxdkVXaCtNLzdEOUhITjk0N\
      HlPRk5UakMveU1UeHEKbG9adjdzWElCOFVwMEJtNUJBdFVmeG1aN3ZsRHFjT2QwU0E1V0VEbFdLW\
      kNVZXNjeU9FQlJnanZCK0lINWowWgptQnlNeFFVZWJzVmlzaUk3SENQWmhFei9pRWI2OHJpdm8yV\
      khRU3ZEY1hiYkFFeVlkTHZwL2RiTEZlOUs0QVJoCmMvSmpmV2VjOUV4RnhvMVhGWUlmQUZyd3IzY\
      zV0Y0N3M0hqUytkS2lXaGxSTnEwV1lhS2lBMU9LQ2h4SVAxSGcKZ2lhZFNMd1Jvb3JpN3FQS1kzQ\
      k5XMDIwNmNvV3VmLzlLbndhbmx1UkQza1ZVY1lXY0dRdTVoZ051WTdzdFBOZwo2c1l6M1RGREhMO\
      UhUbG9pKytXdFVMcjVsWEw1YkFxRzY3MnBGR2s1SUJXd1dVU2IwYjg9Ci0tLS0tRU5EIENFUlRJR\
      klDQVRFLS0tLS0K"
- name: "rancherkub-k8s-2"
  cluster:
    server: "https://172.31.3.91:6443"
    certificate-authority-data: "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN3akNDQ\
      WFxZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFTTVJBd0RnWURWUVFERXdkcmRXSmwKT\
      FdOaE1CNFhEVEl3TVRJd09USXdNemt4TkZvWERUTXdNVEl3TnpJd016a3hORm93RWpFUU1BNEdBM\
      VVFQXhNSAphM1ZpWlMxallUQ0NBU0l3RFFZSktvWklodmNOQVFFQkJRQURnZ0VQQURDQ0FRb0NnZ\
      0VCQUxJNENnN0VCdUJ2CndBbDl5MDVNTUVDZGdWZVR4V0dyZGFTY09BYTc1SERLRFpaTk5QczhWM\
      VBJZW5mWGtNRk1iK3J1Y05SSit0RjcKL0EwaStNd1FzZ1ByZ2cvb2ErM2lrcHlhQmRBNlVqYUhZR\
      zF4TldjTkI1dXdBZWIrUHVCR3NBblE0QmxDeXlvOAorOHh4MVpJL01IK2tBaFEyMnV2YmJjaktic\
      WJzY09mTWowSWxwamdrY3JDTVJuc3pjL24zV0pJR2NwWEhSU0lKCmhNcEhvaEZHdzN5dVpGQTlyR\
      GwwaTlGOW4wUk1yS2Vud20yOVozTE8yaFR2MVBTSXJJQTVieXl3T2V6Y2Mxc28KU3ptOVB5bDZ3R\
      HBzYnp2Vm5HV212WHNidEpDRS83Y3NOZkRyQmpCZ0RVRjJHeEhmbERIb3lzWjJwbjZnU1ZhQQpIT\
      3lmK0FRMzdSVUNBd0VBQWFNak1DRXdEZ1lEVlIwUEFRSC9CQVFEQWdLa01BOEdBMVVkRXdFQi93U\
      UZNQU1CCkFmOHdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSkZBRUtxdkVXaCtNLzdEOUhITjk0N\
      HlPRk5UakMveU1UeHEKbG9adjdzWElCOFVwMEJtNUJBdFVmeG1aN3ZsRHFjT2QwU0E1V0VEbFdLW\
      kNVZXNjeU9FQlJnanZCK0lINWowWgptQnlNeFFVZWJzVmlzaUk3SENQWmhFei9pRWI2OHJpdm8yV\
      khRU3ZEY1hiYkFFeVlkTHZwL2RiTEZlOUs0QVJoCmMvSmpmV2VjOUV4RnhvMVhGWUlmQUZyd3IzY\
      zV0Y0N3M0hqUytkS2lXaGxSTnEwV1lhS2lBMU9LQ2h4SVAxSGcKZ2lhZFNMd1Jvb3JpN3FQS1kzQ\
      k5XMDIwNmNvV3VmLzlLbndhbmx1UkQza1ZVY1lXY0dRdTVoZ051WTdzdFBOZwo2c1l6M1RGREhMO\
      UhUbG9pKytXdFVMcjVsWEw1YkFxRzY3MnBGR2s1SUJXd1dVU2IwYjg9Ci0tLS0tRU5EIENFUlRJR\
      klDQVRFLS0tLS0K"

users:
- name: "rancherkub"
  user:
    token: "kubeconfig-user-jxbzb.c-prxbd:qhbkw5m7z9mstvntknmk49rxh6slw27rbn6f4mqwdrbskrqncjnkqz"

contexts:
- name: "rancherkub"
  context:
    user: "rancherkub"
    cluster: "rancherkub"
- name: "rancherkub-k8s-1"
  context:
    user: "rancherkub"
    cluster: "rancherkub-k8s-1"
- name: "rancherkub-k8s-3"
  context:
    user: "rancherkub"
    cluster: "rancherkub-k8s-3"
- name: "rancherkub-k8s-2"
  context:
    user: "rancherkub"
    cluster: "rancherkub-k8s-2"

current-context: "rancherkub"

# *** IMPLEMENT VOLUME MANAGEMENT SYSTEM ( Rancher Longhorn )

# 4) Rancher Longhorn (Persistent Volume) - Install Rancher Longhorn to manage Persistent Volume
#- ... the idea on having Persistent Volume is to save data of containers and do not lose them in case container is removed... a new container just use that volume once created and data will not be lost

#- on Rancher GUI, cluster created in first step ( name suggested as rancherkub ), select space defaul and just click on 'Apps' and install Rancher Longhorn from it.

# ------------------------------------------------------------

#
# kubectl CLI
#

# 1) MariaDB (Persistent Volume) - Install MariaDB / mysql to as Persistent Volume... It may be managed by Rancher Longhorn we installed previously

#DEPLOY:

kubectl apply -f setup/mariadb-longhorn-volume.yml

# *** IMPLEMENT INGRESS

# 2) Traefik (DNS) - Install Traefik to be used as ingress in Kubernetes cluster by using kubectl CLI

#DEPLOY:

kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/traefik-rbac.yaml
kubectl apply -f https://raw.githubusercontent.com/containous/traefik/v1.7/examples/k8s/traefik-ds.yaml

#- ... once Traefik is installed, we need to finish setup by setting the Traefik URL ( file setup/traefik.yml )

#DEPLOY:

kubectl apply -f setup/traefik.yml

grep host setup/traefik.yml
  - host: traefik.rancher.< your domain >

# FROM THAT POINT ON, ALL ADDITIONAL TOOL OR APPLICATION THAT WILL BE DEPLOYED, IN ORDER TO BE ACCESSED THROUGH DNS (URL) WILL NEED TO HAVE MODULE 'kind: Ingress' IN THEIR YALM MANIFEST FILE

#EX:

apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  namespace: graylog
  name: graylog
  annotations:
    allow.http: "false"
spec:
  rules:
  - host: graylog.rancher.< your domain >
    http:
      paths:
        - path: /
          backend:
            serviceName: graylog
            servicePort: 9000

# *** IMPLEMENT LOG MANAGEMENT SYSTEM

# 3) Graylog - Install centralized system to check containers logs

#DEPLOY:

kubectl apply -f setup/graylog.yml

# ------------------------------------------------------------

#
# GRAYLOG
#

#- Once graylog pod installed ( previous step ), we need to make some configuration via Graylog GUI

# 1)  Create admin user : <user> / <passwd>
# 2)  Click on System -> Input : this is to create an object in Graylog that will receive traffic from container fluentd (fluentd is one of containers belong to Graylog)
# 2a) Select Input = 'GELF UDP' and click on 'Launch new input' button
# 3)  Create an extractor in order to select what will be extract from created input, by click on button 'Manage extractors'
# 3a) Click on 'Load Message' with the default value
# 3b) From the list of extractors, select kubernetes by clicked on 'Select extractor type' -> JSON
# 3c) Fill fiels 'Key prefix' and 'Extractor title' with value 'k8s-' ... the rest keep default values and finally click on button 'Create extractor' button

# The tool is configured .. you may click on button 'Search' on top menu to see the metrics... click on 'Sources' also... explore the tool.

# ------------------------------------------------------------
