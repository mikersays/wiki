---
title: Eddy diffusion (K_zz)
type: concept
created: 2026-05-11
updated: 2026-05-11
---

# Eddy diffusion (K_zz)

Parameter in 1D exoplanet atmosphere models representing **vertical (bulk) mixing** between layers. K_zz governs how strongly chemical disequilibrium signatures (e.g., CO / CO₂ / NH₃ quenching) manifest in observed spectra.

## State of the art (as of May 2026)

- Standard retrievals typically adopt a **single constant K_zz** across the modeled altitude range — a simplifying assumption rather than a physical claim.
- The 2026 [[wd-0806b]] [[jwst|JWST]] paper ([[ben-lew]] et al.; see [[src-aas-nova-wd-0806b-atmosphere-2026-04]]) reports the **first observational evidence that K_zz decreases with altitude** in an exoplanet atmosphere. This argues for altitude-dependent K_zz retrievals as the new baseline for cold giants.

## Implications

- Existing [[exoplanet-atmosphere-models]] of cold giants and [[brown-dwarfs]] may systematically misinterpret chemical-disequilibrium signatures when fitting with a single K_zz value.
- Methodology transfers to other cold direct-imaging targets such as [[epsilon-indi-ab]].
