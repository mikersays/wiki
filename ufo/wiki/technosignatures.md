---
title: Technosignatures
type: concept
created: 2026-04-16
updated: 2026-05-30
---

**Technosignatures** are observable signs of technology that would indicate the presence of an intelligent civilization — as distinct from [[biosignatures]], which indicate the presence of life without requiring intelligence or technology.

## Classical and modern forms

- **Narrowband radio signals** — the 1959 Cocconi & Morrison paper proposed narrowband radio beacons as ideal technosignatures and launched modern [[seti]]
- **Laser pulses / optical SETI**
- **Atmospheric industrial byproducts** (e.g., chlorofluorocarbons, NO₂)
- **Megastructures** (Dyson-sphere-like signatures in IR excess)
- **Waste heat** from stellar-scale civilizations
- **Nighttime artificial light** — see [[nighttime-light-emissions]]; primary calibration target for [[terrestrial-technosignature]] characterization via [[viirs-dnb]] on [[suomi-npp]] ([[src-terrestrial-technosignatures-satellites-2026-04]])

## Broadband leakage (BRaTs, 2026)

[[michael-a-garrett]]'s May 2026 arXiv preprint introduces the **BRaTs** (Broadband Radio Technosignatures) framework ([[src-brats-radio-technosignatures-2026-05]]) as a complement to narrowband SETI. The empirical motivation is that modern terrestrial RF infrastructure has shifted away from narrowband beacons toward distributed wideband digital systems (cellular, Wi-Fi, satellite constellations), so narrowband-only surveys risk classifying real civilizational leakage as unstructured noise. BRaTs uses a tiered pipeline:

1. **Wide-field survey** — next-gen arrays ([[ska|SKA]] and precursors) for initial broadband detection.
2. **VLBI follow-up** — [[vlbi|Very Long Baseline Interferometry]] for sub-milliarcsecond imaging.

Because broadband continuum emission is largely Doppler-drift insensitive, long "SETI Deep Fields" become viable, extending [[kardashev-scale|Kardashev Type I]] leakage detection volume to **~100 pc**. Candidates are discriminated from extragalactic radio sources by joint criteria: high brightness temperature, negligible circular polarization, spectral non-uniformity, interstellar scintillation, and astrometric co-motion with nearby stars/exoplanets.

## Detection pipelines

A modern narrowband technosignature search applies filters like:

- RFI masking
- Multi-beam / multi-antenna directionality checks
- Doppler drift-rate matching to the target's motion
- Zero-drift rejection (eliminates stationary Earth-based sources)
- Occultation checks — does the signal disappear when the planet passes behind the host star
- Temporal evolution and visual inspection

## Key programs and surveys

- [[breakthrough-listen]] — the most comprehensive ongoing technosignature survey
- VLA + MeerKAT K2-18b search (2023, results 2026) — broad, deep null result on a single hycean target ([[src-k2-18b-technosignature-null-2026]])
- [[sardinia-radio-telescope|Sardinia Radio Telescope]] high-frequency survey (Manunza et al. 2025) — first SETI search at **18 GHz** (plus 6 GHz); 36 hrs on the [[galactic-center|Galactic Center]] + 72 [[tess|TESS]] targets; null result; ~5×10⁵ stars constrained at an [[eirp|EIRP]] limit of 1.8×10¹⁹ W. Argues higher frequencies offer a less-congested spectral environment for detection ([[src-sardinia-technosignature-search-2026-05]])
- Upcoming: [[ska|SKA]] (Square Kilometre Array) and ngVLA (next-generation Very Large Array); SKA + [[vlbi]] is the central platform for [[src-brats-radio-technosignatures-2026-05|BRaTs]] broadband leakage surveys

## Interpretation of null results

A technosignature null does not rule out life. It is consistent with: an uninhabited planet, pre-technological life, or technological civilizations using non-radio, broadband, low-duty-cycle, or encrypted signals.

An additional factor: **[[stellar-plasma-scattering]]** — stellar wind plasma turbulence and coronal mass ejections near a transmitting planet can broaden ultra-narrow radio signals before they leave the home system, causing them to fall below standard detection thresholds. [[m-dwarf-stars]] (the most common star type) are highest-risk. Standard [[seti]] pipelines account for interstellar propagation but generally overlook this near-source distortion. See [[src-plasma-technosignature-scattering-2026]].

## Target Prioritization

[[caleb-scharf]]'s 2026 [[interplanetary-habitable-zone]] framework offers a physical-resource basis for predicting where technosignatures should be most detectable: Sol-analog systems with accessible asteroid belts up-weight; active [[m-dwarf-stars|M-dwarf]] systems where civilizations cannot persist (e.g., [[trappist-1]]) down-weight ([[src-interplanetary-habitable-zone-2026]]).

## Earth as calibration target

Earth's outgoing technosignatures — most directly its [[nighttime-light-emissions]] measured by [[viirs-dnb]] — function as a working ground-truth model for what an alien observer might detect from a comparably industrialized exoplanet. See [[terrestrial-technosignature]] for the full subclass list (nighttime light, atmospheric industrial gases, waste heat, RF leakage) and [[christopher-kyba]]'s 2014–2022 global VIIRS DNB analysis ([[src-terrestrial-technosignatures-satellites-2026-04]]). The [[esa]]-proposed [[earth-explorer-13]] dedicated night-lights satellite would deepen this calibration.

[[sofia-sheikh]]'s "Earth Detecting Earth" study quantifies detection ranges for Earth's own emissions: powerful planetary radar (e.g., the decommissioned Arecibo dish) carries far, while everyday 4G LTE leakage is only detectable to ~4 light-years (roughly Proxima Centauri) — a sobering anchor for how faint near-[[kardashev-scale|Kardashev Type I]] leakage actually is ([[src-seti-detecting-earth-technosignatures-2026-05]]).

## AbSciCon26 forward-looking threads (May 2026)

The second [[abscicon26|AbSciCon26]] media tipsheet ([[src-abscicon26-media-tips-2-2026-05]]) surfaces several speculative-edge technosignature threads under active conference discussion:

- **Stellar plasma scattering of alien radio** — extends the near-source signal-distortion problem already covered in [[src-plasma-technosignature-scattering-2026]].
- **Spider pulsars as escape ships** — speculative civilizational use of binary millisecond pulsars.
- **Detectable megamirrors around exoplanets** — software pipelines being designed to identify large reflective megastructures.
- **Exo-Earth detectability** — which exoplanets could observe Earth's biosignature/technosignature via transit photometry.

## Sources

- [[src-k2-18b-technosignature-null-2026]]
- [[src-seti-ai-breakthrough-listen-2025]]
- [[src-plasma-technosignature-scattering-2026]]
- [[src-interplanetary-habitable-zone-2026]]
- [[src-terrestrial-technosignatures-satellites-2026-04]]
- [[src-brats-radio-technosignatures-2026-05]]
- [[src-abscicon26-media-tips-2-2026-05]]
- [[src-seti-detecting-earth-technosignatures-2026-05]]
- [[src-sardinia-technosignature-search-2026-05]]
