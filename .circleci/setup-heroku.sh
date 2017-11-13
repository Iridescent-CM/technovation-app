#!/bin/bash
cat >> ~/.ssh/config << EOF
VerifyHostKeyDNS yes
StrictHostKeyChecking no
EOF
