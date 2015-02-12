NAME=druid
VERSION=0.6.171
RELEASE=0.1
DIST=$(NAME)-$(VERSION).tbz2
DEST=$(shell pwd)
SOURCEDIR=$(DEST)
BUILDDIR=$(DEST)
SRCRPMDIR=$(DEST)
RPMDIR=$(DEST)
RPM_WITH_DIRS = rpmbuild --define "_sourcedir $(SOURCEDIR)" \
            --define "_builddir $(BUILDDIR)" \
            --define "_srcrpmdir $(SRCRPMDIR)" \
            --define "_rpmdir $(RPMDIR)"
dist:
	@printf " * criando pacote ... "
	@date > dist.log
	@rm -rf $(DEST)/$(NAME)-$(VERSION)
	@wget -c http://static.druid.io/artifacts/releases/druid-services-$(VERSION)-bin.tar.gz
	@tar -vzxf druid-services-$(VERSION)-bin.tar.gz
	@cp -R druid-services-$(VERSION)/lib $(DEST)/$(NAME)-$(VERSION)
	@cp -R service/* $(DEST)/$(NAME)-$(VERSION)/
	@(cd $(DEST) ; tar  -jcvf $(DEST)/$(DIST) $(TAR_EXCLUDE) $(NAME)-$(VERSION))  >> dist.log 2>&1
	@rm -rf $(DEST)/$(NAME)-$(VERSION)
	@rm -rf druid-services-$(VERSION)
	@printf "feito.\n"

prep: dist
	$(RPM_WITH_DIRS) -bp $(NAME).spec

rpm: dist
	$(RPM_WITH_DIRS) -ba $(NAME).spec

srpm: dist
	$(RPM_WITH_DIRS) -bs $(NAME).spec

clean:
	@printf " * limpando ('%s')\n" "$(DEST)/$(DIST)"
	@rm -f dist.log $(DEST)/$(DIST)
	@rm -rf $(DEST)/$(NAME)-$(VERSION)
	@rm -rf noarch i386 i686 x86_64
	@rm -f *.src.rpm
