# Ansible Cisco — Network Automation Playbooks

A compact, well-documented collection of Ansible playbooks and configuration helpers to automate Cisco device configuration, testing and provisioning. Built to demonstrate practical network automation skills, secure configuration management, and repeatable deployment workflows — ideal for showing as a portfolio piece during interviews.

Why this repo is valuable to recruiters
- Shows end-to-end automation skills: inventory management, role-free Ansible playbooks, config templates, and device verification.
- Demonstrates Cisco networking knowledge: common switch/router configuration tasks encapsulated in repeatable playbooks.
- Includes practical engineering artifacts: setup script, inventory/reference configs, and variable-driven runs.
- Ready-to-run with minimal prerequisites — easy for reviewers to spin up and evaluate.

Key highlights (skills demonstrated)
- Ansible core: playbooks, inventory, variables, group_vars and idempotent runs
- Networking: Cisco IOS device configuration and templating
- Automation engineering: reproducible setup, documentation, and minimal scripts to bootstrap tests
- Collaboration readiness: clear README, structured repo, and real-world device configuration examples

Quick snapshot
- Primary playbook: `playbook.yml`
- Inventory file: `inventory.yml`
- Configuration helpers: `devices configuration/` (router_conf.txt, switch conf.txt, helper script)
- Bootstrap script: `setup.sh`
- Global variables: `group_vars/all.yml`
- Ansible config: `ansible.cfg`

Prerequisites
- Linux / macOS (or WSL on Windows)
- Ansible (tested with Ansible 2.9+ / 2.10+ — check your environment)
- Network access to Cisco devices (or lab/simulators like Cisco VIRL/GNS3/PacketTracer)
- SSH credentials with appropriate privileges for the devices
- Optional: Python virtualenv for isolation

Quick start — run in your terminal
1. (Optional) Create and activate a Python virtual environment:
```bash
python3 -m venv .venv
source .venv/bin/activate
pip install --upgrade pip
pip install ansible
```

2. Bootstrap repository (installs dependencies / prepares env):
```bash
# make script executable
chmod +x setup.sh
# run the small setup routine
./setup.sh
```

3. Run the playbook (dry-run first, then apply):
```bash
# check syntax & dry run
ansible-playbook -i inventory.yml playbook.yml --syntax-check
ansible-playbook -i inventory.yml playbook.yml --check

# run for real (remove --check)
ansible-playbook -i inventory.yml playbook.yml
```

What this playbook(s) does
- Pushes consolidated configuration snippets to Cisco routers/switches (examples in `devices configuration/`)
- Uses `group_vars/all.yml` to manage reusable variables and credentials
- Demonstrates idempotent behavior and safe, repeatable changes
- Includes a small verification step (where applicable) to validate configuration changes

Repository layout
- `ansible.cfg` — project Ansible configuration (inventory path, default connection settings, etc.)
- `inventory.yml` — example inventory with host groups and connection variables
- `playbook.yml` — main playbook that applies device configuration
- `group_vars/all.yml` — reusable variables for all hosts
- `setup.sh` — helper to prepare local environment
- `devices configuration/` — reference configs and small helper script:
	- `router_conf.txt` — example router configuration snippets
	- `switch conf.txt` — example switch configuration snippets
	- `switch_router_conf.sh` — helper shell script for demonstrations
- `README.md` — this file

How to evaluate / what to look for (for reviewers)
- Look at `playbook.yml` to see how tasks are structured and how variables are applied.
- Inspect `group_vars/all.yml` for multi-environment configuration patterns.
- Check `devices configuration/*` files to see concrete Cisco CLI config examples and how they’re converted to templated automation.
- Optionally run `ansible-playbook --check` to verify idempotence and task behavior without changing devices.

Example outcomes to mention in interviews
- Reduced manual config time — demonstrate raw before/after step counts.
- Idempotence — tasks re-run cleanly with no changes after initial apply.
- Reusability — variables and snippets can be adapted to different device types or sites.

Security notes
- Do not commit real credentials. This repo uses variables for credentials; use Ansible Vault or environment-provisioned secrets for real deployments.
- Limit device access and test in a lab environment before applying to production.

Possible improvements / follow-ups (good talking points)
- Convert device snippets to Jinja2 templates to handle multiple models and OS versions.
- Add molecule or integration tests using simulated devices.
- Add CI to run linting and syntax checks on commits.
- Add Ansible Vault usage and example CI patterns for secret handling.

Contact / Author
- Name: Leonardo (repo owner)
- GitHub: @leoab13
- Email: (add your preferred contact here)
- Quick pitch: "I build repeatable automation for network infrastructure using Ansible, emphasizing idempotence, maintainability, and clear documentation."