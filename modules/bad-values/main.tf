# Cross-repo C2C source-tracing test — the MISCONFIGURATION lives here.
#
# This module declares NO resources. It only exports the insecure values that
# the caller (in aviac) wires into resources it declares itself. The point of
# the test: the resource lives in aviac, but the bad value originates here in
# aviactwo, so the analyzer must trace the misconfig source across repos to
# this module — and the green agent's fix should land here, not on the caller.
