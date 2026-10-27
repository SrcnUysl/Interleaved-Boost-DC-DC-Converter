# Reproducibility and revision notes

The repository combines **more than one development iteration**. Do not assume each source file directly reproduces every plot in the README or each comparison shown.

- **Simulation comparison configuration:** two-phase coupled-inductor boost; nominal 14 V in, 28 V out, 280 W; 100 kHz switching; 10 kHz and 550 Hz design crossover frequencies; multi-rate digital inner / outer sampling of 10 µs / 100 µs.
- **Uploaded MATLAB `parametre.m` configuration:** nominal 14 V in, **24 V out, 240 W**, `Llk=3e-6 H`, `Co=754e-6 F`. The script computes continuous-time loop gains and Tustin coefficients.
- **Simulink `.slx`:** supplied binary model from a separate snapshot. Parameters and block dependencies must be checked in MATLAB/Simulink before running. `parametre.m` is not asserted to initialize the model with the corresponding simulation conditions without modification.
- **LTspice `.asc`:** two original schematic variants. One uses UTF-16LE; preserving the original encoding avoids inadvertent schematic changes. LTspice device-model availability is environment-dependent.
- **Plots:** derived from supplied exported results, not regenerated in this repository. No transient/ripple numbers are independently measured or verified here.
- **Control figures:** the architecture diagram and Bode plots illustrate the control analysis. Redistribution rights for collaboratively prepared illustrations should be checked.

## Reproducing analyses

1. Check the target operating point in *each* source file.
2. Set consistent component parasitics, input voltage, output reference, and load profile across LTspice and Simulink.
3. Verify model dependencies and solver settings.
4. Run start-up, load-step and ripple cases.
5. Compare like-for-like waveforms only. A steady-state graph cannot independently establish phase margin, and simulated waveform comparisons do not amount to hardware qualification.

## Model validation status

All source files are included as received, aside from neutral filenames for the public folder layout. They have **not been executed** in LTspice, MATLAB, or Simulink as part of packaging. Their consistency must be validated by the recipient.
