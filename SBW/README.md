# Spruce Budworm Model (SBW)

This directory contains MATLAB scripts for generating VB (Bifurcation Potential / resilience) fields for the Spruce Budworm (SBW) model, together with tools for overlaying bifurcation curves computed in MatCont.

The SBW model is a classic ecological system exhibiting bistability and fold bifurcations. It provides a biologically motivated example of resilience geometry.

---

## 1. Model

We consider the Spruce Budworm model in the form:

\[
\dot{x} = r x \left(1 - \frac{x}{K}\right) - \frac{x^2}{1 + x^2}
\]

where:

- \( x \) = budworm population density  
- \( r \) = intrinsic growth rate  
- \( K \) = carrying capacity  

The nonlinear predation term produces bistability under appropriate parameter conditions.

Within the bistable region:

- A low-density stable equilibrium (endemic suppression)
- A high-density stable equilibrium (outbreak state)
- A saddle equilibrium separating them

---

## 2. Parameter Plane

The VB field is computed in a selected parameter plane (typically \((K, r)\)).

In the paper, we vary:

- **Horizontal axis:** \( K \)
- **Vertical axis:** \( r \)

Typical ranges used:

```
K ∈ [0, 25]     
r ∈ [0, 0.8]      
grid = 350 × 350
```

---

## 3. Definition of the VB Metric

At each parameter point, the VB value is defined as:

> The distance in phase space between a selected stable equilibrium and its bounding saddle equilibrium.

Because this is a one-dimensional ecological model:

- Phase space is one-dimensional.
- The VB value reduces to the absolute difference:
  
\[
|x_{stable} - x_{saddle}|
\]

The script allows selection of either:

- Low-density equilibrium  
- High-density equilibrium  

The paper specifies which configuration is used.

---

## 4. Generating the VB Field

From within the `SBW/` directory, run:

```matlab
sbw_make_vb("high","K",[0 25],"r",[0 0.8],[350 350]);
```


This generates:

- Raw VB data in `mats/`
- A VB field figure in `figs/`

Smaller grids may be used for testing.

---

## 5. Overlaying Bifurcation Boundaries

Bifurcation curves are computed in **MatCont**.

MatCont project page:

https://sourceforge.net/projects/matcont/

After computing fold (limit point) curves:

1. Copy the `.mat` files into:

```
SBW/mats/
```

The curves used in the paper are already in the mats directory


2. Open the VB field figure.

3. Run:

```matlab
overlayBifurcationBoundary
```

The script:

- Loads curve files specified in `overlay_config.m`
- Uses configured parameter-row mapping
- Overlays the bifurcation curve
- Saves the composite figure to:

```
SBW/figs/
```

---

## 6. Interpretation

The SBW model demonstrates how:

- A biologically realistic system exhibits classical fold-induced bistability.
- Basin geometry shifts as ecological parameters vary.
- Stability margins can be interpreted geometrically as distance to collapse.

As parameters approach the fold boundary:

- The stable equilibrium collides with the saddle.
- The VB value tends toward zero.
- The system becomes increasingly sensitive to perturbations.

This model connects abstract normal forms (SN, CUSP, DW) to ecological systems where resilience has direct applied meaning.

---

## 7. Directory Structure

```
SBW/
│
├── sbw_make_vb.m
├── find_real_eqa_sbw.m
├── classify_equilibria_sbw.m
├── overlayBifurcationBoundary.m
├── overlay_config.m
│
├── mats/
└── figs/
```

---

## 8. Reproducibility Checklist

To reproduce the composite figure:

1. Generate the VB field (350×350 grid).
2. Compute fold curves in MatCont.
3. Copy `.mat` files into `mats/`.
4. Run `overlayBifurcationBoundary`.

The resulting composite figure matches the one presented in the paper.

---
