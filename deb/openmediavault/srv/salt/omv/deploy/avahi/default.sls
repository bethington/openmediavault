# This file is part of OpenMediaVault.
#
# @license   http://www.gnu.org/licenses/gpl.html GPL Version 3
# @author    Volker Theile <volker.theile@openmediavault.org>
# @copyright Copyright (c) 2009-2018 Volker Theile
#
# OpenMediaVault is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# any later version.
#
# OpenMediaVault is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with OpenMediaVault. If not, see <http://www.gnu.org/licenses/>.

# Documentation/Howto:
# https://help.ubuntu.com/community/HowToZeroconf
# http://wiki.ubuntuusers.de/Avahi
# http://www.kde4.de/?page_id=389
# http://wiki.archlinux.org/index.php/Avahi
# http://en.gentoo-wiki.com/wiki/Avahi
# http://www.zaphu.com/2008/04/29/ubuntu-guide-configure-avahi-to-broadcast-services-via-bonjour-to-mac-os-x/
# http://www.dns-sd.org/ServiceTypes.html

configure_default_avahi_daemon:
  file.managed:
    - name: "/etc/default/avahi-daemon"
    - source:
      - salt://{{ slspath }}/files/etc-default-avahi-daemon.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644

configure_avahi_daemon_conf:
  file.managed:
    - name: "/etc/avahi/avahi-daemon.conf"
    - source:
      - salt://{{ slspath }}/files/etc-avahi-avahi-daemon_conf.j2
    - template: jinja
    - user: root
    - group: root
    - mode: 644

# Stop the service.
# Only stop the service because it is always running. Note, it is necessary
# to stop the service instead of simply reload the configuration, otherwise
# the configuration is auto-reloaded in the meanwhile.
# Mask the service to prevent restarting via DBUS (.e.g. shairport-sync or
# forked-daapd).
stop_avahi_service:
  service.dead:
    - name: avahi-daemon
    - enable: True

mask_avahi_service:
  service.masked:
    - name: avahi-daemon

# Build the service configurations.
include:
  - .services

# Start the service.
unmask_avahi_service:
  service.unmasked:
    - name: avahi-daemon

start_avahi_service:
  service.running:
    - name: avahi-daemon
    - enable: True
