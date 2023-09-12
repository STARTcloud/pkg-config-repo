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

PROG=autopass   # App name
VER=1.1         # App version
VERHUMAN=$VER   # Human-readable version
#PVER=          # Branch (set in config.sh, override here if needed)
PKG=autopass            # Package name (e.g. library/foo)
SUMMARY="set an account password to a hash"      # One-liner, must be filled in
DESC="Awk script to let the auto-install set the password to a precomputed hash"         # Longer description, must be filled in

BUILD_DEPENDS_IPS=
RUN_DEPENDS_IPS=

install_bin(){
    logmsg "Creating proto directory"
    logcmd mkdir -p $DESTDIR/usr/sbin || logerr "--- failed to create proto directory"

    logmsg "Copying script"
    logcmd cp autopass $DESTDIR/usr/sbin
    logcmd chmod 0500 $DESTDIR/usr/sbin/autopass
}

init
prep_build
#build
#make_isa_stub
install_bin
make_package
clean_up

# Vim hints
# vim:ts=4:sw=4:et:
