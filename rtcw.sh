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

function _arch_iortcw() {
    # exact parsing from Makefile
    echo "$(uname -m | sed -e 's/i.86/x86/' | sed -e 's/^arm.*/arm/')"
}

function depends_rtcw() {
    local depends=(cmake libsdl2-dev libsdl2-net-dev libsdl2-mixer-dev libsdl2-image-dev timidity freepats)

    if compareVersions "$__os_debian_ver" lt 10; then
        depends+=(libgles1-mesa-dev)
    fi

    getDepends "${depends[@]}"
}

function sources_rtcw() {
    gitPullOrClone "$md_build" https://github.com/iortcw/iortcw.git
}

function build_rtcw() {
    cd "$md_build/SP"

    # Use Case switch to allow future expansion to other potential platforms
    if isPlatform "rpi"; then
        USE_CODEC_VORBIS=0\
                        USE_CODEC_OPUS=0\
                        USE_CURL=0\
                        USE_CURL_DLOPEN=0\
                        USE_OPENAL=1\
                        USE_OPENAL_DLOPEN=1\
                        USE_RENDERER_DLOPEN=0\
                        USE_VOIP=0\
                        USE_LOCAL_HEADERS=1\
                        USE_INTERNAL_JPEG=1\
                        USE_INTERNAL_OPUS=1\
                        USE_INTERNAL_ZLIB=1\
                        USE_OPENGLES=1\
                        USE_BLOOM=0\
                        USE_MUMBLE=0\
                        BUILD_GAME_SO=1\
                        BUILD_RENDERER_REND2=0\
                        ARCH=arm\
                        PLATFORM=linux\
                        COMPILE_ARCH=arm\
                        COMPILE_PLATFORM=linux\
                        make
    else
        make
    fi

    cd "$md_build/MP"

    if isPlatform "rpi"; then
        USE_CODEC_VORBIS=0 \
                        USE_CODEC_OPUS=0\
                        USE_CURL=1\
                        USE_CURL_DLOPEN=1\
                        USE_OPENAL=1\
                        USE_OPENAL_DLOPEN=1\
                        USE_RENDERER_DLOPEN=0\
                        USE_VOIP=0\
                        USE_LOCAL_HEADERS=1\
                        USE_INTERNAL_JPEG=1\
                        USE_INTERNAL_OPUS=1\
                        USE_INTERNAL_ZLIB=1\
                        USE_OPENGLES=1\
                        USE_BLOOM=0\
                        USE_MUMBLE=0\
                        BUILD_GAME_SO=1\
                        BUILD_RENDERER_REND2=0\
                        ARCH=arm\
                        PLATFORM=linux\
                        COMPILE_ARCH=arm\
                        COMPILE_PLATFORM=linux\
                        make
    else
        make
    fi

    md_ret_require="$md_build/SP"
    md_ret_require="$md_build/MP"
}

function install_rtcw() {
    md_ret_files=(
        "SP/build/release-linux-$(_arch_iortcw)/iowolfsp.$(_arch_iortcw)"
        "SP/build/release-linux-$(_arch_iortcw)/main/cgame.sp.$(_arch_iortcw).so"
        "SP/build/release-linux-$(_arch_iortcw)/main/qagame.sp.$(_arch_iortcw).so"
        "SP/build/release-linux-$(_arch_iortcw)/main/ui.sp.$(_arch_iortcw).so"
        "MP/build/release-linux-$(_arch_iortcw)/iowolfded.$(_arch_iortcw)"
        "MP/build/release-linux-$(_arch_iortcw)/iowolfmp.$(_arch_iortcw)"
        "MP/build/release-linux-$(_arch_iortcw)/main/cgame.mp.$(_arch_iortcw).so"
        "MP/build/release-linux-$(_arch_iortcw)/main/qagame.mp.$(_arch_iortcw).so"
        "MP/build/release-linux-$(_arch_iortcw)/main/ui.mp.$(_arch_iortcw).so"
        "MP/build/release-linux-$(_arch_iortcw)/main/vm/"
    )

    if isPlatform "x86"; then
        md_ret_files+=(
            "SP/build/release-linux-$(_arch_iortcw)/renderer_sp_opengl1_$(_arch_iortcw).so"
            "SP/build/release-linux-$(_arch_iortcw)/renderer_sp_rend2_$(_arch_iortcw).so"
            "MP/build/release-linux-$(_arch_iortcw)/renderer_mp_opengl1_$(_arch_iortcw).so"
            "MP/build/release-linux-$(_arch_iortcw)/renderer_mp_rend2_$(_arch_iortcw).so"
        )
    fi
}

function game_data_rtcw() {
    mkdir "$home/.wolf/main"
    mv /opt/retropie/ports/rtcw/[^render*]*.so /opt/retropie/ports/rtcw/main
    mv /opt/retropie/ports/rtcw/vm /opt/retropie/ports/rtcw/main
    cp "$md_data/wolfconfig.cfg" "$home/.wolf/main"
    cp "$md_data/wolfconfig_mp.cfg" "$home/.wolf/main"
    chown -R $user:$user "$romdir/ports/rtcw"
    chown -R $user:$user "$md_conf_root/rtcw-sp"
}

function configure_rtcw() {
    addPort "rtcw-sp" "rtcw-sp" "Return to Castle Wolfenstein (SP)" "$md_inst/iowolfsp.$(_arch_iortcw)"
    addPort "rtcw-mp" "rtcw-mp" "Return to Castle Wolfenstein (MP)" "$md_inst/iowolfmp.$(_arch_iortcw)"

    mkRomDir "ports/rtcw"

    moveConfigDir "$home/.wolf" "$md_conf_root/rtcw-sp"
    moveConfigDir "$md_inst/main" "$romdir/ports/rtcw"

    [[ "$md_mode" == "install" ]] && game_data_rtcw
}

function remove_rtcw() {
    rm $home/.wolf
    rm $home/RetroPie/roms/ports/rtcw/*.so
    rm -R $home/RetroPie/roms/ports/rtcw/vm
}
