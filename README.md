# Two-Phase Interleaved Boost DC–DC Converter

**Converter simulation • Digital control • Analog ACMC • MATLAB/Simulink • LTspice • PCB layout**

A technical portfolio covering the **modeling, controller design, and simulation** of a two-phase coupled-inductor interleaved boost DC–DC converter. The repo includes editable **LTspice** schematics, a **Simulink** model, a **MATLAB** parameter/control-design script, and selected simulation plots.

> **Scope:** The performance figures shown here are from *simulation*, not hardware validation or certified compliance. This repository combines materials from different development iterations; individual files do not necessarily use an identical set of parameters. Publication permissions for third-party or collaboratively owned materials should be confirmed before making this repository public.

## Project at a glance

| Item | Comparative study configuration |
|---|---|
| Topology | Two-phase, 180° interleaved boost with inversely coupled windings |
| Output | 28 V DC, 280 W rated |
| Input range | 12–28 V; nominal 14 V |
| Switching frequency | 100 kHz |
| Control | Cascaded average current-mode control (ACMC): two current loops and one voltage loop |
| Analog model | LTspice, Type-II compensation |
| Digital model | MATLAB/Simulink, digital PI compensation |
| Digital sampling | Inner loop 10 µs; outer loop 100 µs |

The values above describe the **comparison reported in the accompanying simulation study**, *not every source-file revision*. For example, the uploaded `parametre.m` script initializes a **14 V → 24 V, 240 W** variant, with 3 µH leakage inductance. See [Reproducibility and revision notes](docs/REPRODUCIBILITY.md) before running or comparing results.

## PCB design overview

The following design views are shared for illustration of the physical layout workflow; no native KiCad design files are included in this release.

![3D PCB render](images/pcb/pcb_3d_render.png)

<details><summary>More PCB views</summary>

![PCB overview](images/pcb/pcb_layout_full.png)
![PCB all layers](images/pcb/pcb_all_layers.png)
![Copper pours](images/pcb/top_copper_pours.png)
![Inner layer](images/pcb/inner_layer_view.png)

</details>

## Control strategy

A faster **inner current regulation loop** is nested within a slower **outer voltage regulation loop**. The digital PI implementation uses the **Tustin (bilinear)** discretization:

$$u[k] = u[k-1] + q_0 e[k] + q_1 e[k-1]$$

$$q_0=K_p+\frac{K_iT_s}{2},\qquad q_1=-K_p+\frac{K_iT_s}{2}$$

The analog model uses Type-II compensation; both models are intended to explore transient response, regulation, and stability trade-offs.

![ACMC control architecture](images/control/acmc_block_diagram.png)

### Frequency-domain analysis

The small-signal tuning methodology examines **crossover frequency**, **phase margin**, and the relative bandwidths of the current and voltage loops. The following plot is a cropped figure from the collaborative comparative study (authors credited below):

![Inner-current and outer-voltage Bode plots](images/control/controller_bode_plots.png)

## Simulation results

These plots come from the supplied simulation exports. The model settings should be verified before using them to reproduce the study comparison.

### Output-voltage response at multiple input voltages

| 12 V input | 14 V input |
|---|---|
| ![12 V filtered response](results/digital/12V/V12_Vout_Filtered.png) | ![14 V filtered response](results/digital/14V/V14_Vout_Filtered.png) |

| 20 V input | 24 V input |
|---|---|
| ![20 V filtered response](results/digital/20V/V20_Vout_Filtered.png) | ![24 V filtered response](results/digital/24V/V24_Vout_Filtered.png) |

### Detailed waveforms

- [12 V input: currents, ripple, raw and filtered output](results/digital/12V)
- [14 V input: currents, ripple, raw and filtered output](results/digital/14V)
- [20 V input: currents, ripple, raw and filtered output](results/digital/20V)
- [24 V input: currents, ripple, raw and filtered output](results/digital/24V)
- [Additional high-resolution 14 V plots](results/additional)

Example 14 V ripple waveform:

![14 V output ripple](results/digital/14V/V14_VoutRipple.png)

### Analog-versus-digital comparison

The supplied comparative study reports the following **simulated** load-decrease transient metrics at the **14 V nominal input**:

| Metric | Analog ACMC | Digital ACMC |
|---|---:|---:|
| Overshoot | 8.39% | 7.14% |
| Recovery time | 3.28 ms | 2.05 ms |

These are **reported study results**, not measurements from a fabricated converter. Results must not be interpreted as independent certification to MIL-STD-704F or any other standard.

## Source files and usage

| Directory | Files | Software |
|---|---|---|
| [`simulation/ltspice/`](simulation/ltspice) | `Analog_ACMC.asc`, `Analog_ACMC_variant.asc` | LTspice |
| [`simulation/matlab/`](simulation/matlab) | `parametre.m` | MATLAB + Control System Toolbox |
| [`simulation/simulink/`](simulation/simulink) | `Digital_ACMC.slx` | MATLAB/Simulink (required blocks/toolboxes may vary) |
| [`results/digital/`](results/digital) | Digital simulation plots for 12, 14, 20, 24 V | PNG viewer |

**Quick start:**

1. Open an `.asc` file in LTspice and check that its referenced device libraries are available. Select the proper simulation command inside the schematic.
2. Open MATLAB, inspect `simulation/matlab/parametre.m`, and run it to populate the workspace for that *script's* 24 V / 240 W configuration.
3. Open `simulation/simulink/Digital_ACMC.slx` in Simulink. **Inspect and align all model parameters before running**; the supplied MATLAB script and Simulink model are not guaranteed to be matching final revisions.
4. Compare outputs against the corresponding simulation figures only when operating conditions, load steps, and component values match.

The `.slx` model and simulation schematics were not executed or independently verified in this environment.

## Engineering methods illustrated

- Coupled-inductor interleaved boost power stage
- Small-signal modeling and transfer-function loop design
- Nested PI regulators and average current-mode control
- Digital Tustin discretization, sampling constraints, and anti-windup
- Bode analysis and transient-load tests
- Layout visualization and design-for-integration considerations

## Authorship and reuse

The control-architecture and Bode-plot figures were taken from the supplied collaborative manuscript, *Analog and Digital Average Current Mode Control for a 280 W Coupled-Inductor Interleaved Boost Converter: A Comparative Simulation Study*, by **Ahmet Eren Ortak, Mert Mutlu, Arda Sercan Uysal, Umut Baran Ekinci, and Derya Ahmet Kocabaş**. Publication and reuse rights must be verified before public redistribution.

This is an engineering portfolio built from materials supplied by a project participant and a collaborative simulation study. The documentation does not assert sole authorship of collaborative research or grant reuse rights to third-party content. No open-source license is assigned at this stage.
