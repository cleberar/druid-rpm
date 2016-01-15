%define __jar_repack 0
%define _unpackaged_files_terminate_build 0
%define _missing_doc_files_terminate_build 0

Name: druid	
Version: 0.6.171
Release: 0.2
Summary: Druid	
Group: Applications/Internet
License: GPL
URL: http://http://druid.io/
Source: http://static.druid.io/artifacts/releases/druid-services-%{version}-bin.tar.gz
Source1: druid-env.sh.source
Source2: druid-server.initscript.source
BuildRoot: %{_tmppath}/%{name}-root
BuildArch: noarch
AutoReqProv: no

%description
An open-source, real-time data store designed to power interactive applications at scale.

%pre
getent group druid >/dev/null || groupadd -r druid
getent passwd druid >/dev/null || \
    useradd -r -g druid -d /usr/lib/druid -s /sbin/nologin \
    -c "Druid Server Service" druid
exit 0

%prep
%setup -q -n druid-services-%{version}

%build

%install
# create directory skeleton
%{__mkdir_p} %{buildroot}/usr/lib/druid
%{__mkdir_p} %{buildroot}/etc/rc.d/init.d
%{__mkdir_p} %{buildroot}/etc/druid
%{__mkdir_p} %{buildroot}/var/log/druid
%{__mkdir_p} %{buildroot}/var/run/druid

# install custom variables and initscript
install -D -m 644 %{SOURCE1} %{buildroot}/etc/druid/druid-env.sh
install -D -m 755 %{SOURCE2} %{buildroot}/etc/rc.d/init.d/druid-server

# install druid libraries
%{__cp} -Rv lib/* %{buildroot}/usr/lib/druid/


%files
%defattr(-,druid,druid,755)
/usr/lib/druid
%dir /var/log/druid 
%dir /var/run/druid
%defattr(755,root,root)
/etc/rc.d/init.d/druid-server
%defattr(644,root,root)
/etc/druid/druid-env.sh

%clean


%changelog
* Thu Jan 14 2016 Luciano Coutinho <lucianocoutinho@live.com> 0.6.171-0.2
- fixed typos in initscript and updated the build process to preserve 
  original source file as-is.

* Mon Feb 02 2015 Cleber Rodrigues <cleber@cleberar.com> 0.6.171-0.1
- first

