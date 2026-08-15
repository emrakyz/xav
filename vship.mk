CXX := clang++
AR := llvm-ar

CXXFLAGS := -std=c++17 -DNDEBUG -O3 -I include -DVSHIP_VERSION_MAJOR=5 -DVSHIP_VERSION_MINOR=1 -DVSHIP_VERSION_MINORMINOR=0
HOSTFLAGS := -march=native -mtune=native -pipe -ffast-math -fno-math-errno -ffp-contract=fast -fomit-frame-pointer -fno-semantic-interposition -fno-stack-protector -fno-stack-clash-protection -fno-sanitize=all -fno-dwarf2-cfi-asm -fno-pic -fno-pie -fno-plt -fno-stack-check -fno-threadsafe-statics -fno-use-cxa-atexit -fno-unwind-tables -fno-asynchronous-unwind-tables -ftls-model=local-exec -mno-vzeroupper -mharden-sls=none -mno-retpoline -mno-lvi-cfi -mno-lvi-hardening -stdlib=libstdc++ -D_FORTIFY_SOURCE=0
LTOFLAGS := -flto=thin
LDFLAGS := -fuse-ld=lld -no-pie -Wl,-O3,--lto-O3,--as-needed,--gc-sections,--icf=safe,--relax,--strip-all,--discard-all,--build-id=none,-z,norelro,-z,noseparate-code,-znow
VULKANFLAGS := -Wno-ignored-attributes -Wno-unused-variable -Wno-nullability-completeness -Wno-unused-private-field
ifneq ($(VULKAN_SDK), )
	VULKANFLAGS += -I "$(VULKAN_SDK)/include"
endif

.PHONY: buildcuda buildvulkan

buildcuda:
	rm -f libvship.a
	nvcc -x cu src/VshipLib.cpp -ccbin $(CXX) -allow-unsupported-compiler $(CXXFLAGS) -arch=native --use_fast_math --extra-device-vectorization $(addprefix -Xcompiler ,$(HOSTFLAGS)) -lib -o libvship.a

buildvulkan:
	$(CXX) src/Vulkan/spvFileToCppHeader.cpp $(CXXFLAGS) $(HOSTFLAGS) $(LTOFLAGS) $(LDFLAGS) -o shaderEmbedder
	./shaderEmbedder libvshipSpvShaders include/libvshipSpvShaders.hpp
	rm shaderEmbedder
	rm -f libvship.a
	$(CXX) -c src/VshipLib.cpp -DVULKANBUILD $(CXXFLAGS) $(HOSTFLAGS) $(LTOFLAGS) $(VULKANFLAGS) -o vship.o
	$(AR) rcs libvship.a vship.o
	rm vship.o
