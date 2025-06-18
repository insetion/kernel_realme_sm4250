
SECONDS=0 # builtin bash timer

#Set Color
blue='\033[0;34m'
grn='\033[0;32m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
txtbld=$(tput bold)
txtrst=$(tput sgr0)  
export KBUILD_BUILD_USER=UdyneOS
export KBUILD_BUILD_HOST=udyneosprjkt-ubuntu
GAS="$(pwd)/../gas" 
TC_DIR="$(pwd)/../clang" 
export PATH="$TC_DIR/bin:$PATH" 
export PATH="$TC_DIR/:$PATH" 
export PATH="$GAS/bin:$PATH" 
export PATH="$GAS/:$PATH"
DEFCONFIG="vendor/RMX2195_defconfig"
KERNELNAME="Star-Ext"
clear
echo -e " "
echo -e "${txtbld}Config:${txtrst} $DEFCONFIG"
echo -e "${txtbld}ARCH:${txtrst} arm64"
echo -e "${txtbld}Username:${txtrst} $KBUILD_BUILD_USER"
echo -e "$(make kernelversion)-X"


clean() {
echo -e " "
        rm -rf  ./out/
        make O=out clean
        make O=out mrproper
echo -e "Cleared"
sleep 2

}
if [[ $1 == "-mr" || $1 == "Clean" ]]; then
clean
exit
fi
update() {
echo -e " "
        sudo apt-get update 
        sudo apt-get install -y cpio ccache build-essential bc curl git zip ftp gcc-aarch64-linux-gnu gcc-arm-linux-gnueabi libssl-dev lftp zstd wget libfl-dev python3 libarchive-tools device-tree-compiler zsh 
echo -e "dependencies installed"
sleep 2
}

if [[ $1 == "-up" || $1 == "update" ]]; then
update
exit
fi

clang() {
echo -e " "
        git clone https://github.com/1ndev-ui/android_prebuilts_clang_host_linux-x86_clang-6443078 -b 11.0.1 ../clang --depth=1 
        git clone https://android.googlesource.com/platform/prebuilts/gas/linux-x86 -b master ../gas --depth=1 
echo -e "Clone clang Compiler"
sleep 2
}
if [[ $1 == "-cl" || $1 == "clang" ]]; then
clang
fi

compile() {

# rm -rf out && mkdir -p out

echo -e "$blue    \nMake DefConfig\n $nocol"
mkdir -p out
make O=out ARCH=arm64 $DEFCONFIG
grep CONFIG_LOCALVERSION out/.config

sleep 2
# Build start
echo -e "$blue    \nStarting kernel compilation...\n $nocol"
make -j$(nproc --all) O=out ARCH=arm64 CC="ccache clang" CROSS_COMPILE=aarch64-linux-gnu- CROSS_COMPILE_ARM32=arm-linux-gnueabi- CLANG_TRIPLE=aarch64-linux-gnu- LLVM=1
IMAGE=$(pwd)/out/arch/arm64/boot/Image.gz
if ! [ -a "$IMAGE" ]; then
        echo -e "Error"
        exit 1
fi
#git clone --depth=1 -b RMX2195 https://github.com/insetion/Anykernel3.git AnyKernel 
#cp out/arch/arm64/boot/Image.gz AnyKernel
#cp out/arch/arm64/boot/dtbo.img AnyKernel
#cp out/arch/arm64/boot/dtb.img AnyKernel
#sleep 10

}
if [[ $1 == "-gas" || $1 == "build" ]]; then
compile
#echo -e "Compressing to Anykernel.zip"
#cd AnyKernel
#zip -r9 RMX2195-AnyKernel3.zip * -x .git README.md *placeholder
echo -e "$blue    \nKernel Builded check out Folder...\n $nocol"
exit
fi

case "$1" in
  help)
    echo "Cara Pemakaian:"
    echo ""
    echo " Untuk Update repository gunakan -up/ update"
    echo " Untuk Update Clang gunakan -cl/ clang"
    echo " Untuk Mulai Compile gunakan -gas/ build"
    echo " Untuk Hapus cache build gunakan -mr/ Clean"
    echo " credit @mnrdnn/@udyneos"
    ;;
  *)
    echo " Command Not found"
    echo " Use bash build.sh help"
    echo " For help"
    ;;
esac
