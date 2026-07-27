# FONDO Design System

## 1. Brand
- **Name:** FONDO — Smart Subscription Food Delivery
- **Tagline:** "Healthy, scheduled, and customizable meal delivery services"
- **Personality:** Heritage Hearth & Precision — merges traditional Mughlai culinary heritage with clinical high-end dining precision. Sophisticated, warm, trustworthy.
- **Style:** Minimalist with tactile accents. Significant whitespace, restricted palette, food photography and typography lead.

## 2. Color System

### CSS Variable Tokens (use in components)
| Token | Light | Dark | Usage |
|-------|-------|------|-------|
| `--background` | `#FAF5EB` | `#1A1A1A` | Page background |
| `--foreground` | `#16100C` | `#FAF5EB` | Main text |
| `--card` | `#FFFFFF` | `#2C2C2C` | Card background |
| `--card-foreground` | `#16100C` | `#FAF5EB` | Card text |
| `--primary` | `#CEA359` | `#CEA359` | Gold — buttons, accents, premium indicators |
| `--primary-foreground` | `#1B0E08` | `#1B0E08` | Text on primary |
| `--secondary` | `#FBF5EB` | `#2C2C2C` | Cream backgrounds |
| `--secondary-foreground` | `#1B1612` | `#FAF5EB` | Text on secondary |
| `--muted` | `#F5F0E8` | `#2C2C2C` | Subtle backgrounds |
| `--muted-foreground` | `#635C57` | `#9CA3AF` | Muted text |
| `--accent` | `#FBF5EB` | `#2C2C2C` | Accent backgrounds |
| `--accent-foreground` | `#1B1612` | `#FAF5EB` | Text on accent |
| `--destructive` | `#EF4444` | `#EF4444` | Error states, danger badges |
| `--success` | `#10B981` | `#10B981` | Success states |
| `--warning` | `#F59E0B` | `#F59E0B` | Warning states |
| `--border` | `#DDD6CF` | `#3A3A3A` | Borders |
| `--input` | `#DDD6CF` | `#3A3A3A` | Input borders |
| `--ring` | `#CEA359` | `#CEA359` | Focus rings |
| `--sidebar` | `#FFFFFF` | `#1A1A1A` | Sidebar background |
| `--sidebar-foreground` | `#16100C` | `#FAF5EB` | Sidebar text |
| `--sidebar-primary` | `#CEA359` | `#CEA359` | Sidebar primary |
| `--sidebar-primary-foreground` | `#1B0E08` | `#1B0E08` | Sidebar primary text |
| `--sidebar-accent` | `#FBF5EB` | `#2C2C2C` | Sidebar accent |
| `--sidebar-accent-foreground` | `#1B1612` | `#FAF5EB` | Sidebar accent text |
| `--sidebar-border` | `#DDD6CF` | `#3A3A3A` | Sidebar borders |
| `--sidebar-ring` | `#CEA359` | `#CEA359` | Sidebar focus ring |

### Variant System
StatCard, accent bars, and status indicators use these semantic colors:

| Variant | Token | Visual |
|---------|-------|--------|
| `default` | `--primary` | Gold |
| `success` | `--success` | Green |
| `warning` | `--warning` | Amber |
| `danger` | `--destructive` | Red |

### Tier Color System
For customer/profile tiering (bronze/silver/gold):

| Tier | Light bg | Dark bg | Badge | Accent |
|------|----------|---------|-------|--------|
| Bronze | `bg-amber-100/80` | `bg-amber-900/40` | `bg-amber-900/10 text-amber-700` | `bg-amber-600` |
| Silver | `bg-slate-100/70` | `bg-zinc-800/50` | `bg-muted text-muted-foreground` | `bg-slate-400` |
| Gold | `from-primary/15` | `from-amber-800/30` | `bg-primary/10 text-primary` | `bg-primary` |

## 3. Typography

### Font Stack
| Font | CSS Variable | Usage |
|------|-------------|-------|
| Fraunces | `--font-fraunces` | All headings (hero, section titles, card titles, stat values) |
| Inter | `--font-sans` | Body text, UI labels, buttons, badges, prices |

### Type Scale
| Style | Font | Size | Weight | Notes |
|-------|------|------|--------|-------|
| Display | Fraunces | 40px | 700 | Hero |
| Headline-lg | Fraunces | 32px / 28px mobile | 700 | Page titles |
| Headline-md | Fraunces | 24px | 600 | Section headers |
| Card Title | Fraunces | 18px | 600 | Card headings |
| Stat Value | Fraunces | 28-30px | 700 | Dashboard stat cards |
| Body | Inter | 14-16px | 400 | Paragraphs |
| Small | Inter | 12-13px | 400 | Captions, metadata |
| Price | Inter | 18-20px | 700 | Monetary values |
| Label | Inter | 14px | 600, 0.02em | Form labels |
| Badge | Inter | 10-11px | 700, uppercase | Status badges, pills |

**Labels rule:** Use `text-[10px] uppercase tracking-widest` for stat labels and metadata to keep them compact and consistent.

## 4. Layout & Spacing

### Page Structure
| Property | Value |
|----------|-------|
| Max width | 1440px (via `.wrapper` class) |
| Horizontal padding | `clamp(1rem, 0.5rem + 2vw, 3.75rem)` |
| Section gap | `clamp(2rem, 1.5rem + 2.5vw, 5rem)` |
| Grid | 12-column for desktop |

### Container `.wrapper`
```css
.wrapper {
  margin-inline: auto;
  width: 100%;
  max-width: 1440px;
  padding-inline: 1rem;
}
```

### Responsive Breakpoints
| Breakpoint | Width | Layout |
|-----------|-------|--------|
| Mobile | < 768px | Single column, stacked |
| Tablet | 768-1024px | 2 columns |
| Desktop | > 1024px | Full grid |

### Stacking / Spacing
| Token | Value |
|-------|-------|
| Card padding | 16-20px (responsive: `md:p-6`) |
| Input padding | 10-14px |
| Small stack | 8px |
| Medium stack | 16px |
| Large stack | 24px |

## 5. Shadows

| Token | Value | Usage |
|-------|-------|-------|
| `--shadow-card` | `0px 1px 2px rgba(30,26,22,0.04), 0px 8px 24px rgba(30,26,22,0.06)` | Default card elevation |
| `--shadow-badge` | `0px 4px 8px rgba(30,26,22,0.05), 0px 24px 48px -12px rgba(30,26,22,0.18)` | Floating badges, tooltips |
| `--shadow-elevated` | `0px 8px 24px -8px rgba(13,21,40,0.12), 0px 4px 8px -4px rgba(13,21,40,0.06)` | Hover states, popovers |

Use `cn()` helper + Tailwind utilities (e.g. `shadow-[var(--shadow-card)]`). Never hardcode `box-shadow` in components.

## 6. Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-sm` | 0.375rem | Small chips, inline badges |
| `--radius-md` | 0.5rem | Input fields, checkboxes, small cards |
| `--radius-lg` | 0.625rem | Default — cards, dialogs |
| `--radius-xl` | 0.875rem | Medium cards |
| `--radius-2xl` | 1.125rem | Large food cards |
| `--radius-3xl` | 1.375rem | Premium containers, dashboards cards, tables |
| `--radius-4xl` | 1.625rem | Hero sections, prominent surfaces |
| `--radius-full` | 9999px | Pill buttons, avatar circles, badges |

**Dashboard/table containers** always use `rounded-3xl` for premium feel.

## 7. Premium Design Guidelines

These rules apply across all dashboard components, cards, and containers.

### 7.1 Warm Gold Gradient Background
Premium containers use a subtle warm gradient instead of flat `bg-card`:
```
bg-gradient-to-br from-primary/[0.03] via-card to-primary/[0.01]
```
Opacity is low (3% primary at peak) so it reads as a warm glow, not colored.

### 7.2 Depth Layers (Blur Orbs)
Add 2-3 blur orbs per container for depth:
```
<div className="pointer-events-none absolute -bottom-6 -right-6 z-0 size-36 rounded-full bg-primary/8 blur-3xl" />
<div className="pointer-events-none absolute -top-3 -left-3 z-0 size-20 rounded-full bg-primary/5 blur-2xl" />
<div className="pointer-events-none absolute -top-8 -right-8 z-0 size-28 rounded-full bg-primary/5 blur-2xl" />
```
Sizes alternate (`size-36`, `size-20`, `size-28`) and positions avoid overlap.

### 7.3 Diamond Corner
Small rotated square in the top-right as a premium detail:
```
<div className="pointer-events-none absolute right-3 top-3 z-10 size-[7px] rotate-45 border border-primary/30" />
```

### 7.4 Spring Transitions
Every interactive element uses:
```
transition-all duration-500 ease-[cubic-bezier(0.32,0.72,0,1)] active:scale-[0.98]
```
For links/cards that go somewhere, add `hover:shadow-[var(--shadow-elevated)]`.

### 7.5 Gold Dividers
Replace `border-border` solid lines with gradient dividers for premium sections:
```
<div className="h-px w-full bg-gradient-to-r from-primary/40 via-primary/30 to-transparent" />
```

### 7.6 Accent Bars
Stat blocks and metric cards use a 2-6px thick accent bar on one edge:
```
<div className="absolute left-0 top-0 h-full w-1.5 bg-gradient-to-b from-primary to-primary/60" />
```
Positions: left (default), right, top, bottom. Always match bar color to variant.

### 7.7 Colored Top Stripe
For tiered/profile cards, a 4px (`h-1`) colored stripe at the top of the card signals category:
- Bronze: `bg-amber-600`
- Silver: `bg-slate-400`
- Gold: `bg-primary`

### 7.8 Stat Value Emphasis
Stat values always use `font-fraunces` with `tracking-tight` for a premium editorial feel:
```
<p className="font-fraunces text-[30px] font-bold leading-tight tracking-tighter ...">{value}</p>
```

### 7.9 Label Convention
Labels on stat blocks and metadata use a standard format:
```
<p className="text-[10px] uppercase tracking-widest text-muted-foreground">Label</p>
```
Always `text-[10px]`, `uppercase`, `tracking-widest`, `text-muted-foreground`.

### 7.10 Status Pills
Use compact pills for status indicators:
```
<span className="inline-flex items-center gap-1 rounded-full px-2 py-0.5 text-[11px] font-semibold ring-1 bg-success/10 text-success ring-success/20">
  Active
</span>
```
Variants follow the same `bg-{variant}/10 text-{variant} ring-{variant}/20` pattern.

### 7.11 Table Design
- **Wrapper:** Warm gradient + blur orbs + diamond corner
- **Toolbar:** `bg-card` with `border-b border-primary/10`
- **Header/Footer:** `bg-amber-50/80` (light) / `dark:bg-amber-950/30`
- **Rows:** `bg-card`, no zebra, `hover:bg-primary/8`
- **Pagination:** Gold active page with `shadow-[0_2px_8px_rgba(206,163,89,0.25)]`

### 7.12 No Double Bezel
Do not wrap premium containers with `bg-border/15 p-[1px]` inner/outer pattern. Use `overflow-hidden rounded-3xl` with a direct gradient background instead.

## 8. Available shadcn Components (`src/components/ui/`)

Style: **base-nova** | Icons: **Lucide** | RSC: **Yes**

`avatar` · `badge` · `breadcrumb` · `button` · `card` · `checkbox` · `dialog` · `dropdown-menu` · `empty` · `field` · `input` · `label` · `pagination` · `popover` · `select` · `separator` · `sheet` · `sidebar` · `skeleton` · `sonner` · `table` · `tooltip`

Add new ones with `npx shadcn@latest add @shadcn/<name>`.
