#!/bin/bash
# =====================================================
#  Cisco Ansible Setup Script - by Leo
# =====================================================

echo "============================================"
echo "  Configuración automática de Ansible Cisco"
echo "============================================"
echo ""

# --- Solicitar datos de red ---
read -p "Ingresa la IP del ROUTER Cisco: " ROUTER_IP
read -p "Ingresa la IP del SWITCH Cisco: " SWITCH_IP
read -s -p "Ingresa la contraseña de sudo/root: " SUDOPASS
echo ""

# --- Instalar dependencias base ---
echo "Instalando dependencias del sistema..."
echo $SUDOPASS | sudo -S apt update -y
echo $SUDOPASS | sudo -S apt install -y python3 python3-pip python3-venv git sshpass

# --- Configurar SSH para soportar algoritmos antiguos ---
echo "Configurando ~/.ssh/config ..."
mkdir -p ~/.ssh
cat <<EOF > ~/.ssh/config
###########################
#  SSH Config for Cisco
###########################
Host $SWITCH_IP
    User ansible
    KexAlgorithms +diffie-hellman-group1-sha1
    Ciphers +aes128-cbc
    HostKeyAlgorithms +ssh-rsa

Host $ROUTER_IP
    User ansible
    KexAlgorithms +diffie-hellman-group1-sha1
    Ciphers +aes128-cbc
    HostKeyAlgorithms +ssh-rsa
EOF

chmod 600 ~/.ssh/config

# --- Crear estructura de proyecto ---
echo "Creando entorno virtual y estructura..."
cd ~
mkdir -p ~/ansible-cisco
cd ~/ansible-cisco

python3 -m venv venv
source venv/bin/activate

# --- Instalar Ansible y dependencias ---
echo "Instalando Ansible y colecciones..."
pip install --upgrade pip
pip install ansible paramiko netmiko
ansible-galaxy collection install cisco.ios

# --- Crear archivos de configuración ---
echo "Generando archivos de configuración..."

# ansible.cfg
cat <<'EOF' > ansible.cfg
[defaults]
inventory = ./inventory.yml
host_key_checking = False
timeout = 30
interpreter_python = auto
collections_paths = ~/.ansible/collections:/usr/share/ansible/collections
EOF

# inventory.yml
cat <<EOF > inventory.yml
all:
  children:
    routers:
      hosts:
        router1:
          ansible_host: $ROUTER_IP
          ansible_user: ansible
          ansible_password: bl4ck.c4t
          ansible_network_os: cisco.ios.ios
    switches:
      hosts:
        switch1:
          ansible_host: $SWITCH_IP
          ansible_user: ansible
          ansible_password: bl4ck.c4t
          ansible_network_os: cisco.ios.ios
          ansible_ssh_common_args: '-o ProxyCommand="ssh -W %h:%p ansible@$ROUTER_IP"'
EOF

# group_vars/all.yml
mkdir -p group_vars
cat <<'EOF' > group_vars/all.yml
ansible_connection: network_cli
ansible_become: yes
ansible_become_method: enable
ansible_become_password: bl4ck.c4t
EOF

# playbook.yml
cat <<'EOF' > playbook.yml
---
- name: Configure VLAN on Cisco Switches
  hosts: switches
  gather_facts: false
  connection: network_cli
  tasks:
    - name: Configure VLAN 20 on switch
      ios_config:
        lines:
          - vlan 20
          - name prueba2
        save_when: modified

- name: Configure OSPF on Cisco Routers
  hosts: routers
  gather_facts: false
  connection: network_cli
  tasks:
    - name: Configure OSPF process 1
      ios_config:
        parents: router ospf 1
        lines:
          - network 192.168.0.0 0.0.0.255 area 0
        save_when: modified
EOF

# --- Mostrar estructura final ---
echo ""
echo " Estructura creada:"
tree -L 2 ~/ansible-cisco

# --- Ejecutar playbook ---
echo ""
read -p "¿Deseas ejecutar el playbook ahora? (s/n): " RUNNOW
if [[ "$RUNNOW" == "s" || "$RUNNOW" == "S" ]]; then
  echo "Ejecutando playbook..."
  ansible-playbook playbook.yml -vvv
else
  echo "Instalación completa. Puedes ejecutarlo luego con:"
  echo "source ~/ansible-cisco/venv/bin/activate && cd ~/ansible-cisco && ansible-playbook playbook.yml -vvv"
fi

echo ""
echo "Listo. Entorno Ansible Cisco configurado."
