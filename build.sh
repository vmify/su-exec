#!/usr/bin/env sh

VERSION=0.2
SOURCE=https://github.com/ncopa/su-exec/archive/refs/tags/v$VERSION.tar.gz

echo Downloading su-exec "$VERSION" ...
cd /build || exit
wget "$SOURCE"

echo Extracting su-exec "$VERSION" ...
tar -xf v$VERSION.tar.gz
mv su-exec-$VERSION su-exec

echo Building su-exec ...
cd /build/su-exec || exit
make "-j$(nproc)" || exit
strip su-exec
ldd su-exec

echo Packaging su-exec ...
mkdir -p /export/sbin
cd /export || exit

cp /build/su-exec/su-exec sbin
chmod 755 sbin/su-exec

mkdir legal
cat > legal/su-exec<< EOF
Source  : $SOURCE
Version : $VERSION
Package : https://github.com/vmify/su-exec/su-exec/download/$TAG/su-exec-$ARCH-$TAG.tar.gz
License :

EOF
cat /build/su-exec/LICENSE >> legal/su-exec
gzip legal/su-exec

tar -czvf /su-exec.tar.gz *
