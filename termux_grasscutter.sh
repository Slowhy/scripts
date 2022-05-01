#!/data/data/com.termux/files/usr/bin/bash
# Script by Slowhy


install_mongodb(){
    pkg install -y wget openssl-1.1 && apt-mark unhold libicu && pkg remove -y libicu mongodb
    ln -sf /data/data/com.termux/files/usr/lib/openssl-1.1/libcrypto.so.1.1 /data/data/com.termux/files/usr/lib/libcrypto.so.1.1
    ln -sf /data/data/com.termux/files/usr/lib/openssl-1.1/libssl.so.1.1 /data/data/com.termux/files/usr/lib/libssl.so.1.1
    wget https://raw.fastgit.org/Slowhy/scripts/main/libicu_69.1-2_aarch64.deb
    dpkg -i libicu_69.1-2_aarch64.deb
    apt-mark hold libicu && rm -rf libicu_69.1-2_aarch64.deb
    wget -qO- https://its-pointless.github.io/setup-pointless-repo.sh | bash
    echo "deb https://mirrors.ustc.edu.cn/termux-its-pointless/24 termux extras" > $PREFIX/etc/apt/sources.list.d/pointless.list
    pkg update -y && pkg install -y mongodb
}

install_openjdk17(){
    pkg install -y openjdk-17
}

install_mitmproxy(){
    # Install mitmproxy
    pkg install -y python
    export CARGO_BUILD_TARGET=aarch64-linux-android
    pip install mitmproxy
}

install_status(){
    if [ $? -ne 0 ]; then
        echo "\033[31m 安装出错了！ \033[0m";
    else
        echo "\033[32m 安装完成！ \033[0m";
    fi
}

# Initialization
if [ `uname -m` != aarch64 ]; then
    echo "本脚本仅支持arm64(aarch64)架构！"; exit
        elif [ "$TERMUX_VERSION" = "" ]; then
            echo "未检测到Termux版本，请在Termux上运行！"; exit
fi
pkg upgrade -y && clear
case $1 in
    "mongodb")
    install_mongodb&&install_status;;

    "jdk")
    install_openjdk17&&install_status;;

    "mitmproxy")
    install_mitmproxy&&install_status;;

    "all")
    install_mongodb&&install_openjdk17&&install_mitmproxy&&install_status;;

    "nomongodb")
    install_openjdk17&&install_mitmproxy&&install_status;;

    *)
    install_mongodb&&install_openjdk17&&install_mitmproxy&&install_status;;
esac