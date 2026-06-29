# This module hardcodes an insecure ingress rule (SSH open to the world).
# The misconfiguration lives HERE, in aviactwo, not in the caller — that is the
# point of the cross-repo code-to-cloud source-tracing test: a caller in aviac
# instantiates this module, the finding lands on the deployed resource, and the
# repo analyzer should trace the real source of the misconfig back to this file.

resource "aws_security_group" "this" {
  name        = var.name
  description = "Module-defined SG with a hardcoded open SSH rule"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from anywhere - hardcoded in the module (misconfiguration source)"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Project = "wiz-c2c-crossrepo-test"
  }
}
