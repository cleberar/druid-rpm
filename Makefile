NAME=druid
VERSION=0.6.171
RELEASE=0.1
SOURCE_FILE=$(NAME)-services-$(VERSION)-bin.tar.gz

# some variables can be passed by environment variables to help on 
# automate process in any automated buildsystem.
#
# working directory
ifndef DEST
DEST=$(shell pwd)
endif

# source files directory
ifndef SOURCEDIR
SOURCEDIR=$(DEST)
endif

# temporary directory to build the rpms
ifndef BUILDDIR
BUILDDIR=$(DEST)
endif

# source rpm directory (srpm)
ifndef SRCRPMDIR
SRCRPMDIR=$(DEST)
endif

# rpm directory (rpms)
ifndef RPMDIR
RPMDIR=$(DEST)
endif

ifndef DOWNLOAD_URL
SITE=http://static.druid.io/artifacts/releases
DOWNLOAD_URL=$(SITE)/$(SOURCE_FILE)
endif

RPM_WITH_DIRS = rpmbuild --define "_sourcedir $(SOURCEDIR)" \
            --define "_builddir $(BUILDDIR)" \
            --define "_srcrpmdir $(SRCRPMDIR)" \
            --define "_rpmdir $(RPMDIR)"


# using curl instead of wget because nowadays curl is default http
# client in the most linux distros.
CLIENT	?= curl -O -R -S --fail --show-error


# retrieve the stored md5 sum for a source download
define get_sources_md5
$(shell cat sources 2>/dev/null | while read m f ; do if test "$$f" = "$(SOURCE_FILE)" ; then echo $$m ; break ; fi ; done)
endef

# retrieve the md5 sum for locally downloaded file
define get_local_md5
$(shell md5sum $(DEST)/$(SOURCE_FILE) | awk '{print $$1}')
endef

# create rpm and srpm
all: rpm srpm

# download sources from default url
source:
	@if ! test -f $(DEST)/$(SOURCE_FILE) ; then \
		printf " * fazendo download do source tarball...\n" ; \
		$(CLIENT) $(DOWNLOAD_URL) ; \
		printf "feito.\n" ; \
	else \
		printf " * usando source local.\n" ; \
	fi

	@if test "$$(md5sum $(DEST)/$(SOURCE_FILE) | awk '{print $$1}')" != "$(get_sources_md5)" ; then \
		printf "\n * ERRO: md5sum do arquivo baixado " ; \
		printf "é diferente do arquivo 'sources'\n" ; \
		printf "  - cópia local:        %s\n" "$(get_local_md5)" ; \
		printf "  - no arquivo sources: %s\n" "$(get_sources_md5)" ; \
		printf "\n" ; \
		exit 1 ; \
	else \
		ls -l $(DEST)/$(SOURCE_FILE) ; \
	fi

# run rpm "%prepare" macro
prep: source
	$(RPM_WITH_DIRS) -bp $(NAME).spec

# create the rpm only
rpm: source
	$(RPM_WITH_DIRS) -bb $(NAME).spec

# create the srpm only
srpm: source
	$(RPM_WITH_DIRS) -bs $(NAME).spec

# exactly! :-)
clean:
	@printf " * limpando %s\n" "$(DEST)/$(NAME)-$(VERSION)"
	@rm -rf $(DEST)/$(NAME)-$(VERSION)

	@printf " * limpando rpms e srpms.\n"
	@rm -rf $(RPMDIR)/{noarch,i386,i686,x86_64}
	@rm -f $(SRCRPMDIR)/$(NAME)-$(VERSION)*.src.rpm

	@printf " * limpando diretorios temporarios\n"
	@if test -d $(DEST)/druid-services-$(VERSION) ; then \
		rm -rf  $(DEST)/druid-services-$(VERSION) ; \
	fi
	@if test -f $(DEST)/$(SOURCE_FILE) ; then \
		printf " * limpando ('%s')\n" "$(DEST)/$(SOURCE_FILE)" ; \
		rm -f $(DEST)/$(SOURCE_FILE) ; \
	fi

