# Double-Well System (DW)

This directory contains MATLAB scripts for generating VB (Bifurcation Potential / resilience) fields associated with the cubic double-well system, together with tools for overlaying bifurcation curves generated in MatCont.

The scripts reproduce the double-well VB fields presented in:

> *“Bifurcation Potential Fields for Resilience Analysis of Dynamical Systems”*  
> Physica D

---

## 1. Model

We consider the one-dimensional cubic system:

\[
\dot{x} = a x - b - x^3
\]

This system produces the classical double-well bifurcation structure in the \((b, a)\) parameter plane.

Within the bistability wedge:

- Two stable equilibria coexist (left and right wells)
- One saddle equilibrium separates them

The VB field measures the Euclidean distance between a selected stable equilibrium and its bounding saddle.

---

## 2. Generating the VB Field

From within the `DW/` directory, run:

```matlab
% Example:
%   dw_make_vb("low","b",[-1.1 1.1],"a",[0 2],[50 50]);
```

This reproduces the parameter region used in the paper.

### Parameter Ranges Used

```
b ∈ [-1.1, 1.1]
a ∈ [0, 2]
grid = 350 × 350
```

### Output

Running the script generates:

- Raw VB data in `mats/`
- A figure in `figs/`

The script allows switching between:

- Left-well resilience (default)
- Right-well resilience (commented block)

---

## 3. Overlaying Bifurcation Boundaries

Bifurcation curves must first be generated in **MatCont**.

MatCont project page:

https://sourceforge.net/projects/matcont/

After computing the fold (limit point) curves:

1. Copy the resulting `LP_LP(1).mat`, `LP_LP(2).mat` files into:

```
DW/mats/
```

The curves used in the paper are already in the mats directory.

2. Open the VB field figure in MATLAB.

3. Run:

```matlab
overlayBifurcationBoundary
```

The script automatically:

- Loads curve files specified in `overlay_config.m`
- Uses the configured parameter-row mapping
- Overlays the bifurcation boundary
- Saves the composite figure to:

```
DW/figs/
```

---

## 4. Interpretation

Inside the wedge:

- Two attractors coexist.
- The saddle moves as parameters vary.
- The VB field reflects the geometric distance from the selected well to its separating saddle.

As parameters approach the fold boundary, the stable equilibrium collides with the saddle and the VB value tends toward zero.

The field therefore encodes:

- Basin geometry
- Saddle displacement
- Local resilience structure

---

## 5. Directory Structure

```
DW/
│
├── dw_make_vb.m
├── find_real_eqa_dw.m
├── classify_equilibria_dw.m
├── overlayBifurcationBoundary.m
├── overlay_config.m
│
├── mats/
└── figs/
```

---

## 6. Notes

- The overlay script assumes MatCont `.mat` files containing variable `x`.
- Parameter row mapping is defined in `overlay_config.m`.
- This folder is self-contained and independent of other model directories.
- Raw data and composite figures are stored separately for reproducibility.

---

## 7. Reproducibility Checklist

To reproduce the composite figure:

1. Generate the VB field (350×350 grid).
2. Compute fold curves in MatCont.
3. Copy the `.mat` files into `mats/`.
4. Run `overlayBifurcationBoundary`.

The resulting composite figure matches the one presented in the paper.

---
