# CVE-2024-32002 RCE PoC

## Overview

This repository contains a Proof of Concept (PoC) for CVE-2024-32002, a Remote Code Execution (RCE) vulnerability in Git submodules. The exploit demonstrates how a malicious payload can be triggered via a recursive clone of a Git repository.

## Repository Setup

Before running the PoC, create the following repositories on your remote Git server or feel free to change the names as needed:
- `hulk.git`
- `submod.git`
- `smash.git`

Update the repository paths in the PoC script accordingly if you change the names.

## Exploit Details

The exploit leverages Git submodules to execute a payload on the target system when the repository is cloned recursively. This PoC is tested on macOS.

### Define Repository Paths

```sh
HULK_REPO="git@github.com:safebuffer/hulk.git"
pullme_REPO="git@github.com:safebuffer/submod.git"

# Final Exploit Repo
SMASH_REPO="git@github.com:safebuffer/smash.git"
```

### Triggering the Exploit

To trigger the exploit, run the poc.sh script and then execute the following command:
```sh
git clone --recursive $SMASH_REPO
```

### Payload
The default payload in this PoC opens the Calculator application on macOS. You can change this to any payload of your choice.
```sh
/System/Applications/Calculator.app/Contents/MacOS/Calculator
```

### Disclaimer
This PoC is for educational purposes only. Use it responsibly and only on systems where you have explicit permission to test. Misuse of this PoC can result in severe consequences.


