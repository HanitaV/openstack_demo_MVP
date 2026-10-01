# Repository Guidelines

## Project Structure & Module Organization

This repository is a Windows-hosted, Debian DevStack OpenStack MVP for a university demonstration. Keep changes in the layer they serve:

- `windows/`: PowerShell host inspection, Hyper-V enablement, and network helpers.
- `debian/`: Debian-facing installation entry point.
- `ubuntu/`: legacy coursework-required directory name; contains the actual Debian dependency, validation, DevStack, and `local.conf` scripts.
- `openstack/`: ordered, idempotent scripts that create and remove MVP cloud resources. Run them numerically.
- `demo/`: viva presentation and verification commands.
- `docs/`: architecture, setup, troubleshooting, and Vietnamese viva materials.

The MVP scope is intentionally limited to Keystone, Nova, Glance, Neutron, Cinder, and Horizon. Do not introduce production tooling or unrelated OpenStack services.

## Build, Test, and Development Commands

Run deployment commands only inside the Debian VM, as its normal sudo-enabled user:

```bash
chmod +x debian/*.sh ubuntu/*.sh openstack/*.sh demo/*.sh
./debian/install-mvp.sh
./openstack/01-create-project.sh
./demo/verify.sh
```

Use `./demo/demo-all.sh` for the oral-exam sequence and `./openstack/99-cleanup.sh` to remove lab resources. Validate shell syntax before submitting changes:

```bash
find debian ubuntu openstack demo -name '*.sh' -print0 | xargs -0 -n1 bash -n
```

PowerShell scripts should parse without errors using `System.Management.Automation.Language.Parser::ParseFile`.

## Coding Style & Naming Conventions

Write Bash for `bash`, start scripts with `#!/usr/bin/env bash` and `set -Eeuo pipefail`, use two-space indentation only where the surrounding file does, and quote variable expansions. Make resource scripts idempotent: check first, then create or update. Name sequential workflow files `NN-action.sh`; retain resource names such as `mvp-vm01`, `mvp-cirros`, and `mvp-volume01`.

Use PowerShell cmdlets rather than shell aliases. Keep documentation short, command-oriented, and aligned with the low-resource profile: 2 vCPU, 6 GB RAM, and 40 GB disk.

## Testing and Pull Requests

There is no unit-test framework; functional validation is `demo/verify.sh`, which requires a completed DevStack installation and reports each missing resource. For script-only changes, run syntax checks and document any environment-dependent checks not run.

Use concise, imperative commit subjects. Existing history uses summaries such as `INIT` and `Lower MVP resource requirements`. Pull requests should explain the lab impact, list validation performed, and update the relevant documentation when commands, hardware requirements, or service configuration changes.

## Security & Configuration

`openstack` passwords are lab-only defaults. Never add real credentials, IP addresses, cloud images, or generated DevStack state to the repository. Keep KVM detection and the QEMU fallback intact so the MVP remains demonstrable without nested virtualization.
