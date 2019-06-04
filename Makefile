GODOT ?= godot
EXPORT_FLAG ?= --export

all: linux windows mac

linux:
	mkdir -p build/linux
	${GODOT} src/project.godot --export linux ../build/linux/timer.x86_64

mac:
	mkdir -p build/mac
	${GODOT} src/project.godot --export macos ../build/mac/timer_macos.zp
	mv build/mac/timer_macos.zp build/mac/timer_macos.zip
	cd build/mac && unzip timer_macos.zip
	rm build/mac/timer_macos.zip

windows:
	mkdir -p build/windows
	${GODOT} src/project.godot --export windows ../build/windows/timer.exe

release: all
	butler push build/linux duckinator/timer:linux
	butler push build/windows duckinator/timer:windows
	butler push build/mac duckinator/timer:mac

clean:
	rm build/*.zip || exit 0
	rm build/*/* || exit 0

.PHONY: all linux macos windows release clean
