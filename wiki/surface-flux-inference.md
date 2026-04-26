---
title: Surface Flux Inference
type: concept
created: 2026-04-25
updated: 2026-04-25
---

**Surface flux inference** is a method for determining planetary surface gas fluxes from telescope spectra by inverting a coupled [[photochemical-climate-model]], rather than reading off atmospheric gas abundances directly.

## Problem It Addresses

Standard atmospheric retrievals measure the *abundance* of gases like CH₄ or O₂ in an exoplanet atmosphere. But photochemical reactions, climate feedbacks, and atmospheric escape can dramatically alter abundance regardless of the surface source rate — making abundance an unreliable proxy for biological or geological activity. Surface flux inference bypasses this ambiguity by recovering the *rate* at which gases are emitted or absorbed at the surface.

## Method

A forward-running [[photochemical-climate-model]] is used to predict spectra under a range of surface flux scenarios. The model is then inverted against an observed spectrum (Bayesian retrieval) to constrain which surface fluxes are consistent with the data.

## Key Results (Wogan et al. 2026)

- Demonstrated on a synthetic 10-transit [[jwst]] NIRSpec Prism spectrum of [[trappist-1-e]] with an Archean-Earth-like biosphere.
- CH₄ surface flux constrained to within ~1.5 orders of magnitude (68% credible interval).
- ~80% of the CH₄ flux posterior consistent with CH₄-producing metabolism.
- Bottleneck: requires accurate knowledge of the host star's near-UV spectrum.

See [[src-biosignature-gas-flux-inference-2026-04]].

## Significance

Surface flux inference advances beyond the "parallel interpretations" problem flagged by [[sara-seager]] et al. ([[src-jwst-biosignature-prospects-2025]]): even if atmospheric abundance is ambiguous, the inferred surface flux can assign probabilistic weights to biological vs. abiotic explanations.

## Related Pages

- [[photochemical-climate-model]]
- [[biosignatures]]
- [[false-positive-biosignatures]]
- [[jwst]]
- [[trappist-1-e]]
- [[transmission-spectroscopy]]
- [[src-biosignature-gas-flux-inference-2026-04]]
- [[src-jwst-biosignature-prospects-2025]]
