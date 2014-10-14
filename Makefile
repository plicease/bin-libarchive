WGET=wget
RM=rm -f
MV=mv
MKDIR=mkdir -p
PERL=perl

TARGET=i586-mingw32msvc

HOST_ARCH=$(TARGET)

BUILD_ROOT=/home/ollisg/dev/bin-libarchive
BUILD_ARCH=$(TARGET)
BUILD_PREFIX=$(BUILD_ROOT)/local/$(LIBARCHIVE_VERSION)-$(BUILD_ARCH)/libarchive

LIBARCHIVE_VERSION=3.1.2
LIBARCHIVE_SRC_TAR=$(BUILD_ROOT)/src/libarchive-$(LIBARCHIVE_VERSION).tar.gz
LIBARCHIVE_CONFIGURE=--prefix=$(BUILD_PREFIX) \
	--without-xml2                        \
	--host=$(HOST_ARCH)                   \
	--build=$(BUILD_ARCH)
LIBARCHIVE_BIN_TAR=$(BUILD_ROOT)/dist/libarchive-$(LIBARCHIVE_VERSION)-$(BUILD_ARCH).tar.gz
LIBARCHIVE_INSTALLER=$(BUILD_ROOT)/dist/libarchive-$(LIBARCHIVE_VERSION)-$(BUILD_ARCH)-setup.exe
LIBARCHIVE_INSTALLER_OPTIONS=\
	--appname=libarchive			\
	--orgname='White Dactyl Labs'		\
	--version=$(LIBARCHIVE_VERSION)		\
	--nsi=$(BUILD_ROOT)/dist/libarchive-$(LIBARCHIVE_VERSION)-$(BUILD_ARCH)-setup.nsi
	--description='Multi-format archive and compression library'

libarchive: $(LIBARCHIVE_BIN_TAR) $(LIBARCHIVE_INSTALLER)

$(LIBARCHIVE_INSTALLER): $(LIBARCHIVE_BIN_TAR)
	$(PERL) script/create_installer.pl $(LIBARCHIVE_BIN_TAR) --setup=$(LIBARCHIVE_INSTALLER) $(LIBARCHIVE_INSTALLER_OPTIONS)

$(LIBARCHIVE_BIN_TAR): $(LIBARCHIVE_SRC_TAR)
	$(MKDIR) build
	cd build ; tar zxf $(LIBARCHIVE_SRC_TAR)
	cd build/libarchive-$(LIBARCHIVE_VERSION) ; ./configure $(LIBARCHIVE_CONFIGURE) && make V=1 && rm -rf $(BUILD_PREFIX) &&make V=1 install
	$(MKDIR) $(BUILD_ROOT)/dist
	cd $(BUILD_PREFIX)/.. ; tar zcvf $(LIBARCHIVE_BIN_TAR) libarchive

$(LIBARCHIVE_SRC_TAR):
	$(WGET) http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz -O $(LIBARCHIVE_SRC_TAR).tmp
	$(MV) $(LIBARCHIVE_SRC_TAR).tmp $(LIBARCHIVE_SRC_TAR)

clean:
	$(RM) src/*.tmp
	$(RM) -r local
	$(RM) -r build

realclean: clean
	$(RM) src/*.tar.gz