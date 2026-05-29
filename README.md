# Local1 Air-Gapped Multi-Tier Cyber Range

An enterprise-grade, air-gapped simulated local infrastructure designed for advanced penetration testing, packet analysis, and network security auditing. Built entirely using rootless Podman containers on a hardened Linux workstation.

## Architectural Design
This lab moves away from flat container networking to implement true **Zero-Trust Network Segmentation**:
- **DMZ Network (`dmz_network`)**: Houses the edge-facing vulnerable web server.
- **Secure Backplane (`secure_backplane`)**: Completely isolates the MariaDB financial database and the Mail subsystem. The database lacks any direct host port bindings (`3306`), forcing realistic internal network pivoting exercises.
- **Kernel-Level Air-Gap**: Both networks utilize `internal: true` to prevent any unauthorized outbound data exfiltration or host tracking.

## Automation Features
The repository includes `launch-range.sh`, a custom orchestration script that handles service container teardown and deployment. It features an automated log-polling synchronization block that defeats race conditions during initial database and mail socket provisioning before executing safe security account injections.
