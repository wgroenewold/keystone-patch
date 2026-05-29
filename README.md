# keystone-patch

Backport of [Gerrit 990500](https://review.opendev.org/c/openstack/keystone/+/990500)
to OpenStack keystone `unmaintained/2023.1`.

## What this fixes

**LP#2150089** — Delegated tokens (trusts, application credentials, OAuth1
access tokens) did not enforce their project boundary on several Keystone API
endpoints. A compromised delegation token could read or modify credentials
belonging to a different project, create persistent application credentials
that outlive the trust expiry, or enumerate OAuth1 access tokens.

## Affected endpoints

| Endpoint | Problem | Fix |
|---|---|---|
| `GET/POST/PATCH/DELETE /v3/credentials` | No project boundary check for delegated tokens | `_check_credential_project_scope()` |
| `GET/POST/DELETE /v3/users/{id}/credentials/OS-EC2` | No delegation check | `_check_delegation_for_ec2()` |
| `POST /v3/ec2tokens` | OAuth1-backed EC2 cred could auth cross-project | Project ID check at auth time |
| `GET/DELETE /v3/users/{id}/OS-OAUTH1/access_tokens` | No delegation check | `_block_delegated_token()` |
| `GET/POST/DELETE /v3/users/{id}/application_credentials` | Trust/OAuth1 tokens could manage app creds | `_block_delegated_token_app_creds()` |
| `GET/DELETE /v3/users/{id}/access_rules` | Trust/OAuth1 tokens could manage access rules | `_block_delegated_token_app_creds()` |

## How to review

```bash
# Only the security changes — nothing else
git diff HEAD~1
```

## Upstream references

- Gerrit: https://review.opendev.org/c/openstack/keystone/+/990500
- Bug: https://bugs.launchpad.net/keystone/+bug/2150089

## Deployment

Built as a custom Docker image on top of the StackHPC 2023.1 base:

```
172.23.9.249:80/stackhpc/keystone:2023.1-ubuntu-jammy-20240621T104542
```

See `Dockerfile` in this repo.
