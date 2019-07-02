#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="rtcw"
rp_module_desc="RTCW - IORTCW source port of Return to Castle Wolfenstein."
rp_module_licence="GPL3 https://raw.githubusercontent.com/iortcw/iortcw/master/SP/COPYING.txt"
rp_module_help="IORTCW requires the pak files of the full game to play. Add all your singleplayer and multiplayer pak files (mp_bin.pk3, mp_pak0.pk3, mp_pak1.pk3, mp_pak2.pk3, mp_pak3.pk3, mp_pak4.pk3, mp_pak5.pk3, mp_pakmaps0.pk3, mp_pakmaps1.pk3, mp_pakmaps2.pk3, mp_pakmaps3.pk3, mp_pakmaps4.pk3, mp_pakmaps5.pk3, mp_pakmaps6.pk3, pak0.pk3, sp_pak1.pk3, sp_pak2.pk3, sp_pak3.pk3 and sp_pak4.pk3) from your RTCW installation to $romdir/ports/rtcw."
rp_module_section="exp"
rp_module_flags=""

function depends_rtcw() {
    getDepends cmake libsdl2-dev libsdl2-net-dev libsdl2-mixer-dev libsdl2-image-dev timidity freepats
}

function sources_rtcw() {
    gitPullOrClone "$md_build" https://github.com/iortcw/iortcw.git
}

function build_rtcw() {
    cd "$md_build/SP"
    ./make-raspberrypi.sh
    cd "$md_build/MP"
    ./make-raspberrypi.sh
    md_ret_require="$md_build/SP"
    md_ret_require="$md_build/MP"
}

function install_rtcw() {
    md_ret_files=(
        'SP/build/release-linux-arm/iowolfsp.arm'
        'SP/build/release-linux-arm/main/'
        'MP/build/release-linux-arm/iowolfmp.arm'
        'MP/build/release-linux-arm/main/'
    )
}

function game_data_rtcw() {
    mkdir "$home/.wolf/main"
    wget "https://raw.githubusercontent.com/tpo1990/RTCW-RPI/master/wolfconfig.cfg"
    mv wolfconfig.cfg "$home/.wolf/main"
    chown -R $user:$user "$romdir/ports/rtcw"
    chown -R $user:$user "$md_conf_root/rtcw"
}

function configure_rtcw() {
    addPort "$md_id" "rtcw" "Return to Castle Wolfenstein - SP" "$md_inst/iowolfsp.arm"
    addPort "$md_id" "rtcw-mp" "Return to Castle Wolfenstein - MP" "$md_inst/iowolfmp.arm"

    mkRomDir "ports/rtcw"

    moveConfigDir "$home/.wolf" "$md_conf_root/rtcw"
    moveConfigDir "$md_inst/main" "$romdir/ports/rtcw"

    [[ "$md_mode" == "install" ]] && game_data_rtcw
}
