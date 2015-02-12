%define __jar_repack 0
%define _unpackaged_files_terminate_build 0
%define _missing_doc_files_terminate_build 0

Name: druid	
Version: 0.6.171
Release: 0.1
Summary: Druid	
Group: Applications/Internet
License: GPL
URL: http://http://druid.io/
Source: druid-%{version}.tbz2
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
%setup -q

%build

%install

%{__mkdir_p} %{buildroot}/usr/lib/druid
%{__cp} -R * %{buildroot}/usr/lib/druid/

# Copy the service file to the right places
%{__mkdir_p} %{buildroot}/etc/init.d
%{__mkdir_p} %{buildroot}/etc/druid
%{__mkdir_p} %{buildroot}/var/log/druid
%{__mkdir_p} %{buildroot}/var/run/druid

%{__mv} init.d/druid-server %{buildroot}/etc/init.d
%{__mv} env/druid-env.sh %{buildroot}/etc/druid/druid-env.sh

%files
%defattr(-,druid,druid,755)
/usr/lib/druid
%dir /var/log/druid 
%dir /var/run/druid
%defattr(755,root,root)
/etc/init.d/druid-server
%defattr(644,root,root)
/etc/druid/druid-env.sh

%clean


%changelog
* Mon Feb 02 2015 Cleber Rodrigues <cleber@cleberar.com> 0.6.171-0.1
- first

