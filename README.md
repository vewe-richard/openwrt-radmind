# STEPS to build radmind in entware



## 1. Build entware for aarch64
#### 1.1 Setup build env in docker
Refer: https://github.com/Entware/docker/blob/main/README.md

#### 1.2 Clone and compiling,
Refer: https://github.com/Entware/Entware/wiki/Compile-packages-from-sources#clone-the-entware-git-repository

```
cd ~
git clone https://github.com/Entware/Entware.git && cd Entware
make package/symlinks
cp -v configs/aarch64-3.10.config .config
make menuconfig => Save
make -j$(nproc)
```

## 2. Build radmind

```
cd /home/me/Entware
mkdir -p my_packages/net/network/radmind

git clone https://github.com/vewe-richard/openwrt-radmind.git
cp openwrt-radmind/Makefile my_packages/net/network/radmind

#Add 'src-link my_packages /home/me/Entware/my_packages' to feeds.conf
make package/symlinks
make menuconfig #select radmind
make -j1 V=s package/radmind/compile
```

