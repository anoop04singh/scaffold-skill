# Core Contribution
- Novelty in developer terms: The protocol replaces trusted setup-style proving with transparent polynomial commitments and recursive composition, reducing operational ceremony while preserving succinct verification.
- Baseline it replaces/improves: Groth16-style pipeline with setup management and circuit-specific parameters.
- What to implement first: End-to-end prove/verify flow on tiny circuits before any performance tuning.

# Key Primitives
1. Finite field arithmetic
   Purpose: Backbone for constraint evaluation and polynomial operations.
   Implementation strategy: Use a battle-tested field library with canonical serialization.
   Pitfall: Silent overflow or inconsistent modulus handling.
2. Polynomial commitment scheme
   Purpose: Bind prover to polynomial evaluations.
   Implementation strategy: Reuse a maintained PCS crate/library; avoid custom cryptography in MVP.
   Pitfall: Domain separation mistakes in transcript.

# Dependency Map
## Must-have
- Field/curve library (candidate: arkworks or halo2 ecosystem)
- Transcript/hash abstraction
- Serialization codecs

## Nice-to-have
- Benchmark harness
- Differential-testing helpers

## Environment/Tooling
- Reproducible build config
- CI with deterministic test vectors

# Protocol Steps
1. Arithmetize relation
   Intent: Convert computation into constraints.
   Input/Output: Program spec -> constraint system.
   Code hint: Build a `ConstraintBuilder` with explicit witness columns.
2. Commit witness polynomials
   Intent: Bind witness values.
   Input/Output: Witness -> commitments.
   Code hint: Implement `commit_witness(witness, params)`.
3. Derive transcript challenges
   Intent: Make proof non-interactive.
   Input/Output: Commitments -> challenge scalars.
   Code hint: Centralize challenge derivation in `Transcript`.

# Pseudocode
```text
function prove(instance, witness, params):
    cs = arithmetize(instance)
    witness_polys = encode_witness(cs, witness)
    comms = commit_all(witness_polys, params.pcs)
    chall = transcript_challenges(comms, instance.public_inputs)
    evals = evaluate_relations(cs, witness_polys, chall)
    opening = pcs_open(witness_polys, chall.point, params.pcs)
    return Proof(comms, evals, opening)

function verify(instance, proof, vk):
    chall = transcript_challenges(proof.comms, instance.public_inputs)
    ok_rel = check_relation_claims(proof.evals, chall, instance)
    ok_open = pcs_verify(proof.comms, proof.opening, chall.point, vk.pcs)
    return ok_rel and ok_open
```

# Starter Scaffold
## Suggested file layout
```text
zk-protocol/
  src/
    arithmetization.py
    transcript.py
    prover.py
    verifier.py
    types.py
  tests/
    test_roundtrip.py
```

## Skeleton code
```python
from dataclasses import dataclass
from typing import Any

@dataclass
class Proof:
    commitments: Any
    evaluations: Any
    opening: Any

def prove(instance: Any, witness: Any, params: Any) -> Proof:
    # TODO: arithmetize instance
    # TODO: commit witness polynomials
    # TODO: derive transcript challenges
    # TODO: produce opening proof
    return Proof(commitments=None, evaluations=None, opening=None)

def verify(instance: Any, proof: Proof, vk: Any) -> bool:
    # TODO: recompute transcript challenges
    # TODO: validate relation claims
    # TODO: verify PCS opening
    return False

if __name__ == "__main__":
    print("Scaffold ready: implement TODOs to complete protocol.")
```

# Implementation Roadmap
## Phase 1: Bootstrapping
- Deliverables: data model, transcript stub, deterministic test harness.
- Exit criteria: smoke test passes with mocked cryptographic operations.

## Phase 2: Core protocol path
- Deliverables: real commit/open/verify glue path.
- Exit criteria: prove/verify roundtrip passes on toy instance.

## Phase 3: Correctness checks
- Deliverables: negative tests, invariant checks, serialization consistency.
- Exit criteria: invalid proofs fail reliably.

## Phase 4: Optimization/Hardening
- Deliverables: profiling, memory reduction, transcript/domain-separation audit.
- Exit criteria: stable benchmark baseline and security review checklist complete.

# Risks and Validation
## Failure modes
- Challenge reuse across domains
- Mismatch between prover/verifier field encoding
- Non-deterministic serialization breaking verification

## Test plan
- Unit: arithmetic helpers and transcript updates.
- Property/invariant: commitment opening consistency under random inputs.
- Integration: full prove/verify roundtrip with fixtures.
- Performance/security: benchmark proof time and run transcript collision sanity checks.

# Clarifying Assumptions
- Assumption: Paper omits low-level serialization details.
  Impact: medium
- Assumption: Reference PCS library API is stable.
  Impact: low
