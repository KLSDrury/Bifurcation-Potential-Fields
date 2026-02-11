# Forced Duffing Oscillator (DUFF)

This directory contains MATLAB scripts for generating VB (Bifurcation Potential / resilience) fields for the forced Duffing system, together with tools for overlaying bifurcation curves computed in MatCont.

This model is the first two-dimensional system in the repository and illustrates how basin geometry generalizes beyond one-dimensional normal forms.

---

## 1. Model

We consider the forced Duffing oscillator written as a first-order system:

\[
\begin{aligned}
x_1' &= x_2 \\
x_2' &= -a x_1 - b x_1^3 + f
\end{aligned}
\]

Parameters:

- \( a \) — linear stiffness parameter  
- \( b \) — cubic nonlinearity (typically fixed)  
- \( f \) — forcing parameter  

The system exhibits bistability in certain parameter regions, where two stable equilibria coexist and are separated by a saddle.

In the paper, we use:

```
a = variable
f = variable
b = 1
```

---

## 2. Parameter Plane

The VB field is computed in the \((f, a)\) parameter plane:

- **Horizontal axis:** \( f \)
- **Vertical axis:** \( a \)

Ranges used in the paper:

```
f ∈ [-4.25, 4.25]
a ∈ [-5, 0.5]
b = 1
grid = 350 × 350
```

These ranges produce the symmetric bistability wedge shown in the figures.

---

## 3. Definition of the VB Metric

At each parameter point, the VB value is defined as:

> The Euclidean distance in phase space between a selected stable equilibrium and its bounding saddle equilibrium.

Because the system is two-dimensional, equilibria are points in \((x_1, x_2)\)-space. The VB value is therefore:

\[
\| \mathbf{x}_{stable} - \mathbf{x}_{saddle} \|
\]

where \( \| \cdot \| \) denotes the Euclidean norm.

The script selects the high-equilibrium configuration used in the paper.

---

## 4. Generating the VB Field

From within the `DUFF/` directory, run:

```matlab
lowDuffingSweep('f', [-4.25 4.25], 'a', [-5 0.5], [350 350]);
```

This generates:

- Raw VB data in `mats/`
- A VB field figure in `figs/`

Smaller grids (e.g., `[60 60]`) may be used for testing.

---

## 5. Overlaying Bifurcation Boundaries

Bifurcation curves must be computed in **MatCont**.

MatCont project page:

https://sourceforge.net/projects/matcont/

After computing fold (limit point) curves:

1. Copy the resulting `.mat` files into:

```
DUFF/mats/
```

2. Open the VB field figure in MATLAB.

3. Run:

```matlab
overlayBifurcationBoundary
```

The script:

- Loads curve files specified in `overlay_config.m`
- Uses configured parameter-row mapping
- Overlays the bifurcation boundary
- Saves the composite figure to:

```
DUFF/figs/
```

---

## 6. Interpretation

The forced Duffing system demonstrates that:

- VB fields extend naturally to higher-dimensional systems.
- The bifurcation boundary alone does not determine basin geometry.
- The Euclidean saddle distance captures a geometric measure of resilience.

As parameters approach the fold curve, the stable equilibrium collides with the saddle and the VB value approaches zero.

This model bridges one-dimensional normal forms and ecological models appearing later in the repository.

---

## 7. Directory Structure

```
DUFF/
│
├── lowDuffingSweep.m
├── find_real_eqa_duffing.m
├── classify_equilibria_duffing.m
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

The resulting composite matches the figure presented in the paper.

---
