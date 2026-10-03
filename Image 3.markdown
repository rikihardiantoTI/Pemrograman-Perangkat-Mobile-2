---
name: Modern Boutique Commerce
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#3d4947'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#6d7a77'
  outline-variant: '#bcc9c6'
  surface-tint: '#006a61'
  primary: '#00685f'
  on-primary: '#ffffff'
  primary-container: '#008378'
  on-primary-container: '#f4fffc'
  inverse-primary: '#6bd8cb'
  secondary: '#565e74'
  on-secondary: '#ffffff'
  secondary-container: '#dae2fd'
  on-secondary-container: '#5c647a'
  tertiary: '#00685c'
  on-tertiary: '#ffffff'
  tertiary-container: '#008375'
  on-tertiary-container: '#f4fffb'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#89f5e7'
  primary-fixed-dim: '#6bd8cb'
  on-primary-fixed: '#00201d'
  on-primary-fixed-variant: '#005049'
  secondary-fixed: '#dae2fd'
  secondary-fixed-dim: '#bec6e0'
  on-secondary-fixed: '#131b2e'
  on-secondary-fixed-variant: '#3f465c'
  tertiary-fixed: '#62fae3'
  tertiary-fixed-dim: '#3cddc7'
  on-tertiary-fixed: '#00201c'
  on-tertiary-fixed-variant: '#005047'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display-lg:
    fontFamily: Bricolage Grotesque
    fontSize: 2.25rem
    fontWeight: '700'
    lineHeight: 2.5rem
    letterSpacing: -0.03em
  display-md:
    fontFamily: Bricolage Grotesque
    fontSize: 1.75rem
    fontWeight: '600'
    lineHeight: 2rem
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Bricolage Grotesque
    fontSize: 1.5rem
    fontWeight: '600'
    lineHeight: 1.875rem
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Bricolage Grotesque
    fontSize: 1.25rem
    fontWeight: '600'
    lineHeight: 1.625rem
    letterSpacing: -0.015em
  headline-sm:
    fontFamily: Bricolage Grotesque
    fontSize: 1.125rem
    fontWeight: '600'
    lineHeight: 1.5rem
    letterSpacing: -0.01em
  body-lg:
    fontFamily: DM Sans
    fontSize: 1rem
    fontWeight: '400'
    lineHeight: 1.5rem
    letterSpacing: 0em
  body-md:
    fontFamily: DM Sans
    fontSize: 0.875rem
    fontWeight: '400'
    lineHeight: 1.375rem
    letterSpacing: 0em
  body-sm:
    fontFamily: DM Sans
    fontSize: 0.75rem
    fontWeight: '400'
    lineHeight: 1.125rem
    letterSpacing: 0.01em
  label-lg:
    fontFamily: DM Sans
    fontSize: 0.875rem
    fontWeight: '600'
    lineHeight: 1.25rem
    letterSpacing: 0.01em
  label-md:
    fontFamily: DM Sans
    fontSize: 0.75rem
    fontWeight: '600'
    lineHeight: 1rem
    letterSpacing: 0.02em
  label-sm:
    fontFamily: DM Sans
    fontSize: 0.6875rem
    fontWeight: '700'
    lineHeight: 0.875rem
    letterSpacing: 0.04em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-sm: 0.75rem
  margin: 1rem
  margin-tablet: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
  space-2xl: 3rem
---

## Brand & Style

This design system defines a high-end, editorial-inspired mobile e-commerce platform. It blends sharp architectural discipline with curated retail warmth. The experience rejects generic bubble-heavy interfaces in favor of razor-sharp spatial rhythm, confident neo-grotesque display typography, and a grounded spruce-teal foundation.

The target demographic consists of design-literate consumers who value deliberate curation, clarity, and uncompromising product storytelling. The aesthetic balances minimalism with tactile boutique character: crisp hair-thin structural divisions, serene neutral surfaces, and deliberate focal accents that direct conversion flows without visual noise.

## Colors

The palette emphasizes pure canvas whites, tiered slate surfaces, and a rich, grounded spruce-teal signature:

- **Canvas & Surfaces**: The base canvas anchors at `#FFFFFF`. Inset modules, card backgrounds, and layered viewports utilize `#F8FAFC` (surface-container-low) and `#F1F5F9` (surface-container-high) to introduce depth without heavy tinting.
- **Brand Accents**: `#0D9488` functions as the primary interaction key, delivering confidence and high optical contrast against light backdrops. `#2DD4BF` acts as a micro-accent reserved for active badges, stock status indicators, and selected states.
- **Typography & Structure**: Copy is tiered using strict slate scales. Primary headlines and critical metrics leverage `#0F172A`. Secondary metadata and supporting descriptions use `#334155`. Tertiary captions, placeholders, and inactive controls map to `#64748B`.
- **Dividers & Strokes**: Structural containers apply subtle `#E2E8F0` outlines to preserve crisp boundaries against ambient lighting conditions.

## Typography

The pairing creates tension between expressive character and utilitarian precision:

- **Bricolage Grotesque** commands hero narratives, product names, price displays, and sectional headlines. Its subtle idiosyncratic ink-traps and humanist geometry impart a curated boutique presence.
- **DM Sans** delivers uncompromised optical legibility across product specifications, transactional body copy, checkout forms, and tab navigation.
- Letter-spacing tightens slightly on larger Bricolage Grotesque display elements to maintain structural density, while uppercase label tokens employ extended tracking for rapid peripheral scanning.

## Layout & Spacing

The mobile layout model relies on a responsive 4-column structure scaling to 8 columns on tablet widths. Product discovery experiences feature a continuous vertical rhythm anchored to a strict 4px/8px baseline grid:

- **Grid & Safe Zones**: Canvas side margins default to `1rem` on compact phones, transitioning to `1.5rem` on larger viewports. Column gutters maintain a strict `1rem` gap for balanced 2-column e-commerce product grids.
- **Vertical Hierarchy**: Dense internal grouping within components relies on `space-xs` and `space-sm`. Macro separation between product display modules, featured collections, and basket summaries utilizes `space-xl` and `space-2xl` to give photography and editorial content room to breathe.

## Elevation & Depth

Visual hierarchy is communicated through calibrated surface luminance and tight, low-contrast drop shadows rather than stacked blur planes:

- **Level 0 (Flat / Canvas)**: `#FFFFFF` primary background with zero elevation.
- **Level 1 (Card Rest State)**: Product tiles and content containers set against `#FFFFFF` utilize a subtle hairline boundary (`1px solid #E2E8F0`) reinforced by `box-shadow: 0 1px 3px rgba(15, 23, 42, 0.04)`.
- **Level 2 (Interactive Floating / Cart Bars)**: Sticky action trays, floating filter buttons, and navigation bottom sheets employ `box-shadow: 0 4px 12px -2px rgba(15, 23, 42, 0.08)` coupled with an upper boundary hairline.
- **Level 3 (Modal / Checkout Sheets)**: Scrim-backed modal dialogs and slide-over drawers use `box-shadow: 0 12px 32px -4px rgba(15, 23, 42, 0.12)`.

## Shapes

The design system enforces a soft architectural structure (`roundedness: 1`):

- Base controls, badges, chips, and text inputs utilize `0.25rem` (4px) corner radii.
- Content cards, image display thumbnails, and nested modal sheets employ `rounded-lg` (`0.5rem` / 8px).
- Bottom sheet surfaces and floating utility notifications use `rounded-xl` (`0.75rem` / 12px).
- Pill shapes are strictly avoided to ensure the interface maintains an editorial, curated poise rather than a generic toy-like or bubble aesthetic.

## Components

- **Buttons**:
  - *Primary*: Background `#0D9488`, text `#FFFFFF`, 44px min-height for mobile touch targets, font `label-lg`, radius `0.25rem`. Hover/pressed state shifts to `#0F766E`.
  - *Secondary*: Canvas background `#FFFFFF`, border `1px solid #0F172A`, text `#0F172A`.
  - *Tertiary / Ghost*: Transparent background, text `#0F172A`, active underline on focus.
- **Product Cards**:
  - Surface `#FFFFFF` or `#F8FAFC`, bordered with `1px solid #E2E8F0`, corner radius `0.5rem`.
  - Image preview features a 4:5 aspect ratio with zero top-corner bleed.
  - Price display rendered in `Bricolage Grotesque` (`headline-sm`) in `#0F172A`, accompanied by a subtle stock state chip.
- **Chips & Filter Pills**:
  - Inactive: Background `#F1F5F9`, text `#334155`, border `1px solid transparent`, radius `0.25rem`.
  - Active: Background `#0F172A`, text `#FFFFFF`, border `1px solid #0F172A`.
- **Form Inputs**:
  - Background `#FFFFFF`, border `1px solid #CBD5E1`, text `#0F172A`, placeholder `#94A3B8`, radius `0.25rem`. Focus ring applies a crisp `1px solid #0D9488` with a 2px offset.
- **Selection Controls (Checkboxes & Radios)**:
  - Checkboxes use `0.25rem` corners with a 1.5px slate border. Checked state transitions instantly to `#0D9488` with a white geometric checkmark.
- **Sticky Add-to-Cart Bar**:
  - Affixed to viewport bottom with a `1px solid #E2E8F0` top border, `#FFFFFF` background, featuring product unit price alongside a full-width `#0D9488` primary CTA button.