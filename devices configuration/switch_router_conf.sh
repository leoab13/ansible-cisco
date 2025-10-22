#!/usr/bin/env expect

# =====================================================
# Configuración automática Cisco vía minicom/serie
# =====================================================

# Ajusta los puertos serial de tu Linux
# Ejemplo:
set switch_port "/dev/ttyUSB0"
set router_port "/dev/ttyUSB0"

# Contraseña enable (si aplica)
set enable_pass "bl4ck.c4t"

# Configuración Switch
spawn minicom -D $switch_port -b 9600 -o
expect ">"
send "enable\r"
expect "#"
send "$enable_pass\r"
expect "#"
send "configure terminal\r"
expect "(config)#"
send "hostname ansibleSwitch\r"
expect "(config)#"
send "ip domain-name example.com\r"
expect "(config)#"
send "username ansible privilege 15 secret bl4ck.c4t\r"
expect "(config)#"
send "crypto key generate rsa general-keys modulus 2048\r"
expect "(config)#"
send "ip ssh version 2\r"
expect "(config)#"
send "line vty 0 15\r"
expect "(config-line)#"
send "login local\r"
expect "(config-line)#"
send "transport input ssh\r"
expect "(config-line)#"
send "end\r"
expect "#"
send "interface vlan 1\r"
expect "(config-if)#"
send "ip address 192.168.0.2 255.255.255.0\r"
expect "(config-if)#"
send "no shutdown\r"
expect "(config-if)#"
send "exit\r"
expect "#"
send "exit\r"
expect eof

# Configuración Router
spawn minicom -D $router_port -b 9600 -o
expect ">"
send "enable\r"
expect "#"
send "$enable_pass\r"
expect "#"
send "configure terminal\r"
expect "(config)#"
send "hostname ansibleRouter\r"
expect "(config)#"
send "ip domain-name example.com\r"
expect "(config)#"
send "username ansible privilege 15 secret bl4ck.c4t\r"
expect "(config)#"
send "crypto key generate rsa general-keys modulus 2048\r"
expect "(config)#"
send "ip ssh version 2\r"
expect "(config)#"
send "line vty 0 15\r"
expect "(config-line)#"
send "login local\r"
expect "(config-line)#"
send "transport input ssh\r"
expect "(config-line)#"
send "end\r"
expect "(config)#"
send "interface gigabitEthernet0/0\r"
expect "(config-if)#"
send "ip address 192.168.0.4 255.255.255.0\r"
expect "(config-if)#"
send "no shutdown\r"
expect "(config-if)#"
send "exit\r"
expect "#"
send "exit\r"
expect eof
