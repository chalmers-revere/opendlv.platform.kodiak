#!/bin/bash

# incrementalBuild.sh - Script to build opendlv.rhino.
# Copyright (C) 2016 Christian Berger
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

BUILD_AS=$1
UID_AS=$2

# Adding user for building.
groupadd $BUILD_AS
useradd $BUILD_AS -g $BUILD_AS

cat <<EOF > /opt/opendlv.rhino.build/build.sh
#!/bin/bash
cd /opt/opendlv.rhino.build

echo "[opendlv.rhino Docker builder] Incremental build."

mkdir -p build.proxy && cd build.proxy
CCACHE_DIR=/opt/ccache PATH=/usr/lib/ccache:/opt/od4/bin:$PATH cmake -D CXXTEST_INCLUDE_DIR=/opt/opendlv.rhino.sources/thirdparty/cxxtest -D OPENDAVINCI_DIR=/opt/od4 -D ODVDOPENDLVSTANDARDMESSAGESET_DIR=/opt/opendlv.core -D ODVDVEHICLE_DIR=/opt/opendlv.core -D ODVDOPENDLVDATA_DIR=/opt/opendlv -D CMAKE_INSTALL_PREFIX=/opt/opendlv.rhino /opt/opendlv.rhino.sources/code/proxy-rhino

CCACHE_DIR=/opt/ccache PATH=/usr/lib/ccache:/opt/od4/bin:$PATH make -j4 && make test && make install

<<<<<<< HEAD
cd ..

mkdir -p build.system && cd build.system
CCACHE_DIR=/opt/ccache PATH=/usr/lib/ccache:/opt/od4/bin:$PATH cmake -D CXXTEST_INCLUDE_DIR=/opt/opendlv.rhino.sources/thirdparty/cxxtest -D OPENDAVINCI_DIR=/opt/od4 -D ODVDOPENDLVSTANDARDMESSAGESET_DIR=/opt/opendlv.core -D ODVDVEHICLE_DIR=/opt/opendlv.core -D ODVDOPENDLVDATA_DIR=/opt/opendlv -D CMAKE_INSTALL_PREFIX=/opt/opendlv.rhino /opt/opendlv.rhino.sources/code/system-rhino

CCACHE_DIR=/opt/ccache PATH=/usr/lib/ccache:/opt/od4/bin:$PATH make -j4 && make test && make install

=======
>>>>>>> 3e80a56bd605ab8bbbd6ffb116b60904c841ba29
EOF

chmod 755 /opt/opendlv.rhino.build/build.sh
chown $UID_AS:$UID_AS /opt/opendlv.rhino.build/build.sh
chown -R $UID_AS:$UID_AS /opt

su -m `getent passwd $UID_AS|cut -f1 -d":"` -c /opt/opendlv.rhino.build/build.sh

