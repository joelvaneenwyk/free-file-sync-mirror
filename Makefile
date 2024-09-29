CXX ?= g++
exeName = FreeFileSync_$(shell arch)

CXXFLAGS += -std=c++23 -pipe -DWXINTL_NO_GETTEXT_MACRO -I../.. -I./zenXml -include "zen/i18n.h" -include "zen/warn_static.h" \
           -Wall -Wfatal-errors -Wmissing-include-dirs -Wswitch-enum -Wcast-align -Wnon-virtual-dtor -Wno-unused-function -Wshadow -Wno-maybe-uninitialized \
           -O3 -DNDEBUG `wx-config --cxxflags --debug=no` -pthread

LDFLAGS += -s -no-pie `wx-config --libs std, aui, richtext --debug=no` -pthread


CXXFLAGS  += `pkg-config --cflags openssl`
LDFLAGS += `pkg-config --libs   openssl`

CXXFLAGS  += `pkg-config --cflags libcurl`
LDFLAGS += `pkg-config --libs   libcurl`

CXXFLAGS  += `pkg-config --cflags libssh2`
LDFLAGS += `pkg-config --libs   libssh2`

CXXFLAGS  += `pkg-config --cflags gtk+-2.0`
#treat as system headers so that warnings are hidden:
CXXFLAGS  += -isystem/usr/include/gtk-2.0

#support for SELinux (optional)
SELINUX_EXISTING=$(shell pkg-config --exists libselinux && echo YES)
ifeq ($(SELINUX_EXISTING),YES)
CXXFLAGS  += `pkg-config --cflags libselinux` -DHAVE_SELINUX
LDFLAGS += `pkg-config --libs libselinux`
endif

cppFiles=
cppFiles+=./FreeFileSync/Source/application.cpp
cppFiles+=./FreeFileSync/Source/base_tools.cpp
cppFiles+=./FreeFileSync/Source/config.cpp
cppFiles+=./FreeFileSync/Source/ffs_paths.cpp
cppFiles+=./FreeFileSync/Source/icon_buffer.cpp
cppFiles+=./FreeFileSync/Source/localization.cpp
cppFiles+=./FreeFileSync/Source/log_file.cpp
cppFiles+=./FreeFileSync/Source/status_handler.cpp
cppFiles+=./FreeFileSync/Source/base/algorithm.cpp
cppFiles+=./FreeFileSync/Source/base/binary.cpp
cppFiles+=./FreeFileSync/Source/base/comparison.cpp
cppFiles+=./FreeFileSync/Source/base/db_file.cpp
cppFiles+=./FreeFileSync/Source/base/dir_lock.cpp
cppFiles+=./FreeFileSync/Source/base/file_hierarchy.cpp
cppFiles+=./FreeFileSync/Source/base/icon_loader.cpp
cppFiles+=./FreeFileSync/Source/base/multi_rename.cpp
cppFiles+=./FreeFileSync/Source/base/parallel_scan.cpp
cppFiles+=./FreeFileSync/Source/base/path_filter.cpp
cppFiles+=./FreeFileSync/Source/base/speed_test.cpp
cppFiles+=./FreeFileSync/Source/base/structures.cpp
cppFiles+=./FreeFileSync/Source/base/synchronization.cpp
cppFiles+=./FreeFileSync/Source/base/versioning.cpp
cppFiles+=./FreeFileSync/Source/afs/abstract.cpp
cppFiles+=./FreeFileSync/Source/afs/concrete.cpp
cppFiles+=./FreeFileSync/Source/afs/ftp.cpp
cppFiles+=./FreeFileSync/Source/afs/gdrive.cpp
cppFiles+=./FreeFileSync/Source/afs/init_curl_libssh2.cpp
cppFiles+=./FreeFileSync/Source/afs/native.cpp
cppFiles+=./FreeFileSync/Source/afs/sftp.cpp
cppFiles+=./FreeFileSync/Source/ui/batch_config.cpp
cppFiles+=./FreeFileSync/Source/ui/abstract_folder_picker.cpp
cppFiles+=./FreeFileSync/Source/ui/batch_status_handler.cpp
cppFiles+=./FreeFileSync/Source/ui/cfg_grid.cpp
cppFiles+=./FreeFileSync/Source/ui/command_box.cpp
cppFiles+=./FreeFileSync/Source/ui/folder_history_box.cpp
cppFiles+=./FreeFileSync/Source/ui/folder_selector.cpp
cppFiles+=./FreeFileSync/Source/ui/file_grid.cpp
cppFiles+=./FreeFileSync/Source/ui/file_view.cpp
cppFiles+=./FreeFileSync/Source/ui/log_panel.cpp
cppFiles+=./FreeFileSync/Source/ui/tree_grid.cpp
cppFiles+=./FreeFileSync/Source/ui/gui_generated.cpp
cppFiles+=./FreeFileSync/Source/ui/gui_status_handler.cpp
cppFiles+=./FreeFileSync/Source/ui/main_dlg.cpp
cppFiles+=./FreeFileSync/Source/ui/progress_indicator.cpp
cppFiles+=./FreeFileSync/Source/ui/rename_dlg.cpp
cppFiles+=./FreeFileSync/Source/ui/search_grid.cpp
cppFiles+=./FreeFileSync/Source/ui/small_dlgs.cpp
cppFiles+=./FreeFileSync/Source/ui/sync_cfg.cpp
cppFiles+=./FreeFileSync/Source/ui/tray_icon.cpp
cppFiles+=./FreeFileSync/Source/ui/triple_splitter.cpp
cppFiles+=./FreeFileSync/Source/ui/version_check.cpp
cppFiles+=./libcurl/curl_wrap.cpp
cppFiles+=./zen/argon2.cpp
cppFiles+=./zen/file_access.cpp
cppFiles+=./zen/file_io.cpp
cppFiles+=./zen/file_path.cpp
cppFiles+=./zen/file_traverser.cpp
cppFiles+=./zen/http.cpp
cppFiles+=./zen/zstring.cpp
cppFiles+=./zen/format_unit.cpp
cppFiles+=./zen/legacy_compiler.cpp
cppFiles+=./zen/open_ssl.cpp
cppFiles+=./zen/process_priority.cpp
cppFiles+=./zen/recycler.cpp
cppFiles+=./zen/resolve_path.cpp
cppFiles+=./zen/process_exec.cpp
cppFiles+=./zen/shutdown.cpp
cppFiles+=./zen/sys_error.cpp
cppFiles+=./zen/sys_info.cpp
cppFiles+=./zen/sys_version.cpp
cppFiles+=./zen/thread.cpp
cppFiles+=./zen/zlib_wrap.cpp
cppFiles+=./wx+/file_drop.cpp
cppFiles+=./wx+/grid.cpp
cppFiles+=./wx+/image_tools.cpp
cppFiles+=./wx+/graph.cpp
cppFiles+=./wx+/taskbar.cpp
cppFiles+=./wx+/tooltip.cpp
cppFiles+=./wx+/image_resources.cpp
cppFiles+=./wx+/popup_dlg.cpp
cppFiles+=./wx+/popup_dlg_generated.cpp
cppFiles+=./xBRZ/src/xbrz.cpp

tmpPath = $(shell dirname "$(shell mktemp -u)")/$(exeName)_Make

objFiles = $(cppFiles:%=$(tmpPath)/ffs/src/%.o)

all: ./FreeFileSync/Build/Bin/$(exeName)

free-file-sync:
	make -C ./FreeFileSync/Source all

./FreeFileSync/Build/Bin/$(exeName): $(objFiles)
	mkdir -p $(dir $@)
	$(CXX) -o $@ $^ $(LDFLAGS)

$(tmpPath)/ffs/src/%.o : %
	mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -rf $(tmpPath)
	rm -f ./FreeFileSync/Build/Bin/$(exeName)
