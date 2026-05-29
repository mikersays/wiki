---
title: Exoplanet atmosphere models
type: concept
created: 2026-05-09
updated: 2026-05-11
---

# Exoplanet atmosphere models

Forward and retrieval models used to interpret exoplanet transmission, emission, and reflection spectra. The dominant frameworks couple radiative transfer with chemical-equilibrium or kinetic chemistry, increasingly with self-consistent thermal profiles.

## Known gaps

- **Clouds and hazes** — most production models are cloud-free or use parameterized grey clouds because real cloud microphysics (nucleation, sedimentation, lateral patchiness) is computationally expensive. The 2026 [[src-jwst-ice-clouds-exoplanet-2026-04]] result on [[water-ice-clouds]] in [[epsilon-indi-ab]] is one of the most explicit cases where this gap demonstrably misreads atmospheric composition.
- **Photochemistry false-positives** — abiotic O₂ and CH₄ pathways are still being mapped (see [[src-oxygen-false-positive-biosignatures-2026-03]]).
- **3D dynamics** — most retrievals assume 1D atmospheres; rotation, day-night terminator effects, and patchy cloud decks are open problems. The 2026 limb-resolved JWST study of [[hot-jupiter]] [[wasp-94ab]] is the strongest case yet that terminator/limb asymmetry breaks 1D blended-limb retrievals: separating the cloudy morning limb from the clear evening limb corrected the planet's oxygen/carbon abundance from "hundreds of times" to ~5× Jupiter ([[src-jwst-wasp-94ab-weather-cycle-2026-05]]).

## Related pages

- [[water-ice-clouds]]
- [[direct-imaging]]
- [[jwst]]
- [[src-jwst-ice-clouds-exoplanet-2026-04]]
- [[src-jwst-toi-1130b-atmosphere-2026-05]]
- [[src-jwst-biosignature-prospects-2025]]
- [[src-oxygen-false-positive-biosignatures-2026-03]]
- [[src-biosignature-gas-flux-inference-2026-04]]
- [[src-sciencedaily-forbidden-exoplanet-atmosphere-2026-04]] — [[toi-5205-b]] stress-tests the bulk-tracks-atmosphere assumption: bulk planet is ~100× more metal-rich than the visible atmosphere (interior/atmosphere decoupling).
- [[src-aas-nova-wd-0806b-atmosphere-2026-04]] — [[wd-0806b]] yields the first observational evidence that **vertical mixing ([[eddy-diffusion|K_zz]]) weakens with altitude** — argues against the single-K_zz simplification standard in 1D retrievals.
- [[src-jwst-wasp-94ab-weather-cycle-2026-05]] — [[wasp-94ab]] shows a repeating morning-cloud/evening-clear weather cycle; demonstrates that limb-blended retrievals systematically bias inferred metallicity for [[hot-jupiter|hot Jupiters]] (also seen on WASP-39b, WASP-17b).
