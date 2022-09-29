---
title: Kubernetes(K8s)集群搭建
author: LanXuage
date: 2022-09-29 09:48:48 +0800
categories: [运维]
tags: [K8s, Kubernetes, 集群, containerd]
---

# 节点硬件配置要求

- 不能使用交换分区: `swapoff /path/to/endpoint`
- 物理内存不能少于1700M（除去系统占用，建议设置为2G）: `free -m`
- CPU核心数不能少于2: `lscpu`

# 部署过程

## 1、确保每个节点上 MAC 地址和 product_uuid 的唯一性

```sh
# 查看 MAC 地址
ip link
ifconfig -a

# 查看 product_uuid 
sudo cat /sys/class/dmi/id/product_uuid
```

## 2、允许 iptables 桥接流量

### （可选）2.1、确保 br_netfilter 模块被加载

```sh
# 查看，内核比较新的系统可能没有任何显示
lsmod | grep br_netfilter

# 执行显式加载
sudo modprobe br_netfilter
```

### 2.2、确保在 sysctl 配置中将 net.bridge.bridge-nf-call-iptables 设置为 1

```sh
# 添加需要的模块，其中 ip_vs 相关模块为 kubeProxy 模式为 ipvs 时所需要加载的模块
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
ip_vs
ip_vs_rr
ip_vs_wrr
ip_vs_sh
nf_conntrack
EOF

# 添加 IP 转发和桥接
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF

# 显式生效
sudo sysctl --system
```

## 3、安装容器运行时（docker或者containerd）

### 3.1、docker 安装

> docker 本身也是采用的 containerd 容器运行时

```sh
curl -fsSL https://get.docker.com | bash -s docker --mirror Aliyun
```

### 3.2、containerd 安装

```sh
# 可在源码仓库(https://github.com/containerd/containerd/releases)处下载最新的 cri 压缩包直接于解压到根目录即可。
tar -C / -zxvf cri-containerd-1.6.7-linux-amd64.tar.gz
# 初始化配置文件
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
# 启动并设为自启
systemctl enable containerd --now
```

## 4、使用阿里云源安装 kubelet、kubeadm 和 kubectl。

```sh
apt-get update && apt-get install -y apt-transport-https
curl https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-get install -y ipvsadm ipset # ipvs
# 一般情况都会设为开机启动
systemctl enable kubelet
```

## pre-5、生成 init 配置文件

```sh
kubeadm config print init-defaults --component-configs KubeletConfiguration --component-configs KubeProxyConfiguration > kubeadm-config.yml
```

### 基本配置

```yml
# 配置当前节点的 IP ，即集群 kube-apiserver 的监听地址，也就是 master 节点
localAPIEndpoint:
  advertiseAddress: 172.29.9.51  

# 检查criSocket 配置项，如果使用containerd运行时的话正常内容应该是containerd的sock文件（unix:///var/run/containerd/containerd.sock), docker默认为：/var/run/dockershim.sock
nodeRegistration:
  criSocket: /var/run/dockershim.sock
```

### 确保关闭防火墙

```sh
# 查看
ufw status
# 关闭
ufw disable
```


## 5、配置 cgroup 驱动
> 确保容器运行时的 cgroup 驱动和 kubelet 的 cgroup 驱动一致。官方推荐使用 systemd。

### 5.1、配置容器运行时 cgroup 驱动

#### docker

docker 配置方式：修改 docker 配置文件 `/etc/docker/daemon.json`，添加下面内容已启用systemd，

```json
{
  "exec-opts": ["native.cgroupdriver=systemd"]
}
```

查看 docker 当前使用的 cgroup 驱动

```
docker info
```

#### containerd

修改 `/etc/containerd/config.toml` 配置文件，

```sh
[plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
  ...
  [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    SystemdCgroup = true  # 将该项改为true，默认为false
    ....

# 可以采用sed命令
sed -i "s/SystemdCgroup = false/SystemdCgroup = true/g" /etc/containerd/config.toml
```

### 5.2、配置 kubelet 的 cgroup 驱动

kubeadm 支持在执行 kubeadm init 时，传递一个 KubeletConfiguration 结构体。 KubeletConfiguration 包含 cgroupDriver 字段，可用于控制 kubelet 的 cgroup 驱动。如果用户没有在 KubeletConfiguration 中设置 cgroupDriver 字段， kubeadm init 会将它设置为默认值 systemd。

```yml
# kubeadm-config.yaml
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
cgroupDriver: systemd # 确保这一项为所需的cgroup
```

### （可选）5.3、配置IPVS

```yml
# kubeadm-config.yaml
---
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
mode: ipvs # 使用ipvs
```

### 5.4、配置镜像拉取的仓库地址

配置集群初始化时使用的镜像仓库地址，默认为 `k8s.gcr.io` ，国内可换成 `registry.aliyuncs.com/k8sxio` 或者 `registry.cn-hangzhou.aliyuncs.com/google_containers` 等地址

```yml
# kubeadm-config.yml 
imageRepository: k8s.gcr.io
kind: ClusterConfiguration
```

### （可选）5.5、配置 flannel 网段

```yml
networking:
  dnsDomain: cluster.local
  podSubnet: 10.244.0.0/16
  serviceSubnet: 10.96.0.0/12
```

### （可选）5.6、配置 calico 网段

```yml
networking:
  dnsDomain: cluster.local
  podSubnet: 192.168.0.0/16
  serviceSubnet: 10.96.0.0/12
```

## 6、使用 kubeadm 创建集群

### （可选）6.1、 配置国内网络问题解决

#### 配置 docker 代理

```sh
mkdir -p /etc/systemd/system/docker.service.d

cat <<EOF >/etc/systemd/system/docker.service.d/proxy.conf
[Service]
Environment="HTTP_PROXY=socks5://127.0.0.1:1080" "HTTPS_PROXY=socks5://127.0.0.1:1080" "NO_PROXY=localhost,127.0.0.1,daocloud.io,docker.io"
EOF

systemctl daemon-reload
systemctl restart docker
```

#### 配置 containerd 加速仓库

> 文件/etc/containerd/config.toml

```sh
[plugins."io.containerd.grpc.v1.cri".registry]
  [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]   # 可选
      endpoint = ["https://{你的ID}.mirror.aliyuncs.com"]                # 可选
    [plugins."io.containerd.grpc.v1.cri".registry.mirrors."k8s.gcr.io"]
      endpoint = ["https://registry.aliyuncs.com/k8sxio"]                 # 最好与前面 kubeadm-config.yml 初始化配置时使用的仓库地址一致。
```

### 6.2、拉取 k8s 所需镜像

```sh
kubeadm config images pull
```

### 6.3、初始化 k8s 节点

```sh
kubeadm init
# 使用配置文件
kubeadm init --config kubeadm-config.yml | tee kubeadm-config.log
```

### 6.4、设置 Master 节点

```sh
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# 可选（root）
export KUBECONFIG=/etc/kubernetes/admin.conf
```

### 6.5、加入集群

```sh
kubeadm join 172.16.202.131:6443 --token yi2yxa.xg14zufpkum0ldy8 --discovery-token-ca-cert-hash sha256:be3398aeb75e6224ee06f8f9011e602c9dd8eaa70ed65dbb1c4a3e94cefdb463
```

### 6.6 配置网络插件

```sh
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
```

## python 库

https://github.com/kubernetes-client/python