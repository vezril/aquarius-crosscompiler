#!/usr/bin/env bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as sudo"
  exit
fi

export PREFIX="/usr/local/cross"
export TARGET=i686-elf
export PATH="$PREFIX/bin:$PATH"

mkdir -p $PREFIX
mkdir ../src
cd ../src

wget ftp://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz
#wget ftp://ftp.gnu.org/gnu/binutils/binutils-2.25.tar.gz.sig
tar xfzv binutils-2.25.tar.gz

wget ftp://ftp.gnu.org/gnu/gcc/gcc-4.9.2/gcc-4.9.2.tar.gz
#ftp://ftp.gnu.org/gnu/gcc/gcc-4.9.2/gcc-4.9.2.tar.gz.sig
tar xfzv gcc-4.9.2.tar.gz

wget ftp://gcc.gnu.org/pub/gcc/infrastructure/mpc-0.8.1.tar.gz
tar xfzv mpc-0.8.1.tar.gz
mv mpc-0.8.1 gcc-4.9.2/mpc
wget ftp://gcc.gnu.org/pub/gcc/infrastructure/mpfr-2.4.2.tar.bz2
tar xfjv mpfr-2.4.2.tar.bz2
mv mpfr-2.4.2 gcc-4.9.2/mpfr
wget ftp://gcc.gnu.org/pub/gcc/infrastructure/gmp-4.3.2.tar.bz2
tar xfjv gmp-4.3.2.tar.bz2
mv gmp-4.3.2 gcc-4.9.2/gmp

#######################
## Building binutils ##
#######################

#cd $HOME/src

# If you wish to build these packages as part of binutils:
#mv isl-x.y.z binutils-x.y.z/isl
#mv cloog-x.y.z binutils-x.y.z/cloog
# But reconsider: You should just get the development packages from your OS.

mkdir build-binutils
cd build-binutils
../binutils-2.25/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make
make install

##################
## Building GCC ##
##################

#cd $HOME/src

# If you wish to build these packages as part of gcc:
#mv libiconv-x.y.z gcc-x.y.z/libiconv # Mac OS X users
#mv gmp-x.y.z gcc-x.y.z/gmp
#mv mpfr-x.y.z gcc-x.y.z/mpfr
#mv mpc-x.y.z gcc-x.y.z/mpc
#mv isl-x.y.z gcc-x.y.z/isl
#mv cloog-x.y.z gcc-x.y.z/cloog
# But reconsider: You should just get the development packages from your OS.

# The $PREFIX/bin dir _must_ be in the PATH. We did that above.
#which -- $TARGET-as || echo $TARGET-as is not in the PATH

mkdir build-gcc
cd build-gcc
../gcc-4.9.2/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make all-gcc
make all-target-libgcc
make install-gcc
make install-target-libgcc
