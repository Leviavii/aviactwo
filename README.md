# aviactwo

Terraform modules for a cross-repo code-to-cloud source-tracing test.

## modules/insecure-sg
A security group module that **hardcodes** an insecure ingress rule (SSH from `0.0.0.0/0`).
The misconfiguration intentionally lives in this module, not in the caller, so the repo
analyzer's source tracing can be tested across repositories: the caller lives in `aviac`,
the real source of the misconfiguration lives here in `aviactwo`.
