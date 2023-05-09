# 
# Do NOT Edit the Auto-generated Part!
# Generated by: spectacle version 0.27
# 

Name:       harbour-fibonacci
# >> macros
%define __provides_exclude_from ^%{_datadir}/%{name}/lib/.*\\.so\\>
%define __requires_exclude_from ^%{_datadir}/%{name}/lib/.*\\.so\\>
%define __requires_exclude ^libc|libdl|libm|libpthread|libpython3.7m|libpython3.4m|python|env|libutil.*$
# << macros

%{!?qtc_qmake:%define qtc_qmake %qmake}
%{!?qtc_qmake5:%define qtc_qmake5 %qmake5}
%{!?qtc_make:%define qtc_make make}
%{?qtc_builddir:%define _builddir %qtc_builddir}

Summary:    RPN Calculator with exprtk programmagle interface for SailfishOS.
Version:    0.9
Release:    1
Group:      Qt/Qt
License:    GPL
URL:        https://github.com/poetaster/fibonacci
Source0:    %{name}-%{version}.tar.bz2

#Source1:    https://files.pythonhosted.org/packages/s/fastcache/fastcache-1.0.2.tar.gz
#Source2:    https://files.pythonhosted.org/packages/s/mpmath/mpmath-0.19.tar.gz
#Source3:    https://files.pythonhosted.org/packages/s/sympy/sympy-0.7.6.1.tar.gz
#Source4:    https://files.pythonhosted.org/packages/s/dice/dice-1.0.2.tar.gz

Requires:   sailfishsilica-qt5 >= 0.10.9
Requires:   pyotherside-qml-plugin-python3-qt5 >= 1.3.0
Requires:   jolla-keyboard
BuildRequires:  pkgconfig(sailfishapp) >= 1.0.2
BuildRequires:  pkgconfig(Qt5Core)
BuildRequires:  pkgconfig(Qt5Qml)
BuildRequires:  pkgconfig(Qt5Quick)
BuildRequires:  desktop-file-utils
BuildRequires:  python3-base
BuildRequires:  python3-devel

%description
Full symbolic RPN calculator using Sympy with a programmable calculator using exprtk c++.
Based in part on https://github.com/lainwir3d/sailfish-rpn-calculator

%if "%{?vendor}" == "chum"
PackageName: fibonacci
Type: desktop-application
Categories:
 - Science
 - Utility
DeveloperName: Mark Washeim (poetaster)
Custom:
 - Repo: https://github.com/poetaster/fibonacci
Icon: https://raw.githubusercontent.com/poetaster/fibonacci/main/icons/172x172/harbour-fibonacci.png
Screenshots:
 - https://raw.githubusercontent.com/poetaster/fibonacci/main/screenshot-1.png
 - https://raw.githubusercontent.com/poetaster/fibonacci/main/screenshot-2.png
 - https://raw.githubusercontent.com/poetaster/fibonacci/main/screenshot-3.png
Url:
  Donation: https://www.paypal.me/poetasterFOSS
%endif

%prep
%setup -q -n %{name}-%{version}

# >> setup
# << setup

%build
# >> build pre
# << build pre

%qtc_qmake5 

%qtc_make %{?_smp_mflags}


%install
rm -rf %{buildroot}

# >> install pre
# << install pre
%qmake5_install

# << install post

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop


cd %{buildroot}%{_datadir}/%{name}/lib/sympy-0.7.6.1
python3 setup.py install --root=%{buildroot} --prefix=%{_datadir}/%{name}/
rm -rf  %{buildroot}%{_datadir}/%{name}/lib/sympy-0.7.6.1

cd %{buildroot}/%{_datadir}/%{name}/lib/pyparsing-2.0.3
python3 setup.py install --root=%{buildroot} --prefix=%{_datadir}/%{name}/
rm -rf %{buildroot}/%{_datadir}/%{name}/lib/pyparsing-2.0.3

cd %{buildroot}/%{_datadir}/%{name}/lib/mpmath-0.19
python3 setup.py install --root=%{buildroot} --prefix=%{_datadir}/%{name}/
rm -rf %{buildroot}/%{_datadir}/%{name}/lib/mpmath-0.19

cd %{buildroot}/%{_datadir}/%{name}/lib/dice-1.0.2
python3 setup.py install --root=%{buildroot} --prefix=%{_datadir}/%{name}/
rm -rf %{buildroot}/%{_datadir}/%{name}/lib/dice-1.0.2

rm -rf %{buildroot}/%{_datadir}/%{name}/share
rm -rf %{buildroot}/%{_datadir}/%{name}/bin

cd %_builddir

%post
# >> post
killall maliit-server
# << post
%postun
# >> postun
killall maliit-server
# << postun

%files
%defattr(-,root,root,-)
%{_bindir}
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
%{_datadir}/maliit/plugins/com/jolla/layouts/programmers.qml
%{_datadir}/maliit/plugins/com/jolla/layouts/layouts_programmers.conf
# >> files
# << files
