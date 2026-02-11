# Unfolded Saddle-Node (SN) Model

This folder contains MATLAB scripts to reproduce the VB (resilience) field and bifurcation overlays for the **unfolded saddle-node (fold) normal form**:

\[
\dot{x} = a + \frac{b^2}{4} + b x + x^2.
\]

This model serves as the canonical one–dimensional prototype for a fold bifurcation and provides the simplest setting in which basin geometry and bifurcation structure can be compared directly.

---

## 1. Parameter Plane

The VB field is computed over the parameter plane:

- **Horizontal axis:** \( a \)
- **Vertical axis:** \( b \)

Typical ranges used in the paper:

- \( a \in [-1.5, 0.5] \)
- \( b \in [-0.5, 1.5] \)

Within this plane, the vertical line \( a = 0 \) corresponds to the fold (limit point) bifurcation curve separating monostability from bistability.

---

## 2. What the VB Field Measures

At each parameter point, the VB value is defined as:

> The distance (in phase space) from a selected stable equilibrium  
> to its bounding saddle equilibrium.

This produces a scalar field over parameter space encoding basin geometry.

Two focal configurations are supported:

- `"low"`  — lower stable equilibrium  
- `"high"` — upper stable equilibrium  

The paper uses the **high equilibrium** configuration.

---

## 3. Geometric Interpretation

This model illustrates an important geometric principle:

- For the **low equilibrium**, level sets of the VB field are nearly vertical.
- For the **high equilibrium**, level sets become oblique.

The difference arises because the saddle moves relative to the upper branch as parameters vary. Thus, identical bifurcation boundaries can produce qualitatively different resilience landscapes depending on which equilibrium is examined.

This distinction is central to the interpretation of VB fields throughout the paper.

---

## 4. Reproducing the VB Field

From MATLAB, inside this folder, run:

```matlab
sn_make_vb("high","a",[-1.5 0.5],"b",[-0.5 1.5],[350 350]);
```

This generates:

Raw VB data (saved to mats/)

A VB figure (saved to figs/)

For exploratory purposes, smaller grids (e.g., [60 60]) may be used.

5. Overlaying Bifurcation Boundaries

Bifurcation curves were generated using MatCont.

Step 1: Place MatCont curve files in SN/mats/

Typical files: LP_LP(1).mat, LP_LP(2).mat

Step 2: With the VB figure open, run overlayBifurcationBoundary

The auto-named composite figure (VB field + bifurcation curve) is automatically saved to: SN/figs/

6. Notes for Students

The fold curve corresponds to loss of one equilibrium–saddle pair.

The VB field does not merely replicate the bifurcation boundary.

Instead, it encodes how far a system is from basin collapse.

Different focal equilibria can produce distinct VB geometries even when bifurcation structure is identical.

This model provides the simplest demonstration that bifurcation curves alone do not uniquely determine resilience geometry — a theme that recurs in higher-dimensional models.


