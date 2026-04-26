---
title: Biosignatures
type: concept
created: 2026-04-13
updated: 2026-04-16
---

# Biosignatures

A **biosignature** is any substance, structure, or pattern that provides scientific evidence of past or present life. A **potential biosignature** is one that might have a biological origin but requires further study before conclusions about life can be reached.

## Types of Biosignatures

### Atmospheric Biosignatures
Gases in a planet's atmosphere that are predominantly or exclusively produced by biological processes:

- **Dimethyl sulfide (DMS)**: On Earth, exclusively produced by marine phytoplankton. According to [[src-jwst-k2-18b-biosignature-2025]], DMS was detected on exoplanet K2-18b by [[jwst]], though at concentrations thousands of times Earth levels.
- **Dimethyl disulfide (DMDS)**: Also exclusively biogenic on Earth; tentatively detected on K2-18b.
- **Oxygen / ozone**: Can indicate photosynthesis but also has abiotic sources. On M-dwarf rocky planets, CO₂ photolysis generates detectable abiotic O₂/O₃ — a classic [[false-positive-biosignatures|false-positive]]. 2026 photochemical modeling refined the maximum abiotic O₂ to ~2.7% on Mars-like atmospheres (driven by water-vapor HOx recycling) — ~10× lower than prior estimates ([[src-oxygen-false-positive-biosignatures-2026-03]]).
- **Methane**: Detected on K2-18b; can be biogenic or abiogenic.

### Mineral/Chemical Biosignatures
Minerals or chemical patterns associated with biological processes:

- **Vivianite** (hydrated iron phosphate): Found near decaying organic matter on Earth. Detected in the Cheyava Falls rock on Mars by [[perseverance-rover]] ([[src-mars-perseverance-biosignature-2025]]).
- **Greigite** (iron sulfide): Associated with iron-reducing and sulfate-reducing bacteria. Also found in Cheyava Falls.
- **"Leopard spot" patterns**: Nodules and reaction fronts characteristic of microbial redox activity.

### Technosignatures
Indicators of technological activity by intelligent life:

- Narrow-band radio signals, laser pulses, or other electromagnetic emissions
- [[breakthrough-listen]] searches for technosignatures across the Milky Way ([[src-seti-ai-breakthrough-listen-2025]])

## Detection Challenges

- **Statistical significance**: The K2-18b DMS detection reached three-sigma (0.3% chance of random occurrence) but falls short of the five-sigma threshold required for definitive discovery.
- **Abiotic mimics**: Many biosignature candidates can be produced by non-biological processes (volcanism, meteorite delivery, photochemistry).
- **Extraordinary evidence**: As Katie Stack Morgan noted, "astrobiological claims... require extraordinary evidence."

## Surface Flux Inference — Beyond Abundance Retrieval

Wogan et al. (2026) propose that atmospheric abundance measurements are insufficient for life detection because photochemistry, climate feedbacks, and atmospheric escape modulate gas concentrations independently of the surface source. Their **[[surface-flux-inference]]** method inverts a coupled [[photochemical-climate-model]] against [[jwst]] spectra to recover surface gas fluxes directly. In a synthetic 10-transit NIRSpec Prism spectrum of [[trappist-1-e]], ~80% of the CH₄ flux posterior was consistent with methanogenic metabolism. See [[src-biosignature-gas-flux-inference-2026-04]].

## The "Silver Bullet" Critique — Parallel Interpretations

In a 2025 PNAS perspective ([[src-jwst-biosignature-prospects-2025]]), [[sara-seager]] et al. argue the single-gas "silver bullet" biosignature paradigm is not achievable with [[jwst]]. The same [[transmission-spectroscopy|transmission spectrum]] admits multiple valid atmospheric retrievals — "parallel interpretations" that may not resolve until next-gen observatories ([[habitable-worlds-observatory]], [[life-interferometer|LIFE]]) come online. Only a handful of habitable-zone atmospheres are accessible before JWST's noise floor, and transmission spectra are 1D averages of 3D atmospheric processes. Seager et al. also note that oxygen took billions of years to reach 20% on Earth even after oxygenic photosynthesis evolved — so for much of Earth's inhabited history, O₂ was only a trace gas, narrowing the temporal window during which Earth itself would have looked "biosignatured" from afar.

## Biosignature Survival

Research by Alexander Pavlov (NASA Goddard, 2024) on [[ocean-worlds]]:

- On Enceladus: amino acids survive at less than a few millimeters below surface
- On Europa: amino acids viable to ~20 cm depth at high latitudes
- Amino acids degrade faster in silica-rich regions

## K2-18b Status (2026 Update)

The DMS/DMDS biosignature claim on [[k2-18b]] is described in the 2026 technosignature follow-up paper as "heavily disputed." A parallel VLA + MeerKAT [[technosignatures|technosignature]] search on the same target returned a null result ([[src-k2-18b-technosignature-null-2026]]). The combined picture — a contested biosignature plus a technosignature null on the same planet — makes K2-18b a methodologically important case study.

## See Also

- [[astrobiology]]
- [[exoplanet-habitability]]
- [[ocean-worlds]]
- [[seti]]
- [[k2-18b]]
- [[hycean-worlds]]
- [[technosignatures]]
- [[false-positive-biosignatures]]
