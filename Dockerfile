FROM 172.23.9.249:80/stackhpc/keystone:2023.1-ubuntu-jammy-20240621T104542

# Backport of LP#2150089 (Gerrit 990500): enforce delegation project boundary.
# See README.md for details.

COPY keystone/api/_shared/EC2_S3_Resource.py \
     /var/lib/kolla/venv/lib/python3.10/site-packages/keystone/api/_shared/EC2_S3_Resource.py

COPY keystone/api/credentials.py \
     /var/lib/kolla/venv/lib/python3.10/site-packages/keystone/api/credentials.py

COPY keystone/api/users.py \
     /var/lib/kolla/venv/lib/python3.10/site-packages/keystone/api/users.py

COPY keystone/conf/security_compliance.py \
     /var/lib/kolla/venv/lib/python3.10/site-packages/keystone/conf/security_compliance.py
