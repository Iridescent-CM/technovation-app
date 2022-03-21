#!/bin/bash
cat > ~/.netrc << EOF
machine api.heroku.com
  login $NEW_HEROKU_LOGIN
  password $NEW_HEROKU_API_KEY
EOF

cat >> ~/.ssh/config << EOF
VerifyHostKeyDNS yes
StrictHostKeyChecking no
EOF
