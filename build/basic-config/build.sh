#!/usr/bin/bash
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License, Version 1.0 only
# (the "License").  You may not use this file except in compliance
# with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2016 OmniTI Computer Consulting, Inc.  All rights reserved.
# Use is subject to license terms.
#
# Load support functions
. ../../lib/functions.sh

PROG=basic-config # App name
VER=1.0            # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=basic-config            # Package name (e.g. library/foo)
SUMMARY="A package to set up some defaults"      # One-liner, must be filled in
DESC="This package sets up sane defaults that omniosce hosts and vm." # Longer description, must be filled in

BUILD_DEPENDS_IPS=
RUN_DEPENDS_IPS=

install_bin(){
    logmsg "Creating proto directory"
    logcmd mkdir -p $DESTDIR/opt/startcloud/bin || logerr "--- failed to create /opt/startcloud/bin in proto directory"
    logcmd mkdir -p $DESTDIR/boot/conf.d || logerr "--- failed to create /boot/conf.d proto directory"
    logcmd mkdir -p $DESTDIR/lib/svc/manifest/system || logerr "--- failed to create /lib/svc/manifest/system in proto directory"

    logcmd cp basic-config.sh $DESTDIR/opt/startcloud/bin || logerr "--- failed to copy basic-config.sh"
    logcmd cp serial $DESTDIR/boot/conf.d || logerr "--- failed to copy serial"
    logcmd cp basic-config.xml $DESTDIR/lib/svc/manifest/system || logerr "--- failed to copy basic-config.xml"
}


init
patch_source
prep_build
#build
#make_isa_stub
install_bin
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
