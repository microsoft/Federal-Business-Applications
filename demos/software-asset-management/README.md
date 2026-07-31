# Software Asset Management

A lightweight, model-driven Power Apps solution that helps a Contracting Officer track software purchasing actions ("Inquiries"), the products and vendors involved, and the lifecycle of each action from draft to fulfillment. Built entirely on Microsoft Dataverse and validated in a GCC (US Gov) environment.

## The problem this solves

Contracting teams often manage software purchases in spreadsheets and email, which makes it hard to answer basic questions: *What are we buying, from whom, for how much, and what's expiring soon?* This solution gives a command a single, structured system of record to:

- Maintain a catalog of **vendors**, **products** (with SKU and price), and their **primary contacts**.
- Capture each purchasing **inquiry** with its line-item products, quantities, per-product POC, period of performance, and business justification.
- Automatically total the cost of an inquiry from its line items.
- Move each inquiry through a governed **Draft → In Review → Award & Fulfillment** process with built-in review gates.
- Surface inquiries with **upcoming period-of-performance end dates** so the team can act before contracts lapse.

## Essential features

- **Five related tables** modeling vendors, products, inquiries, inquiry line items, and the process itself, using out-of-the-box Contact and User tables where possible.
- **Business Process Flow** ("Inquiry Process") that guides users through Draft, In Review, and Award & Fulfillment stages.
- **Stage-gate enforcement** — a client script blocks advancement out of Draft until required attestations are complete.
- **Automated rollups and timestamps** — inquiry total cost recalculates from line items, and stage milestone dates are stamped automatically.
- **Review outcome automation** — approve, reject, return-for-rework, or withdraw decisions drive status changes and reset the process as needed.
- **Auto-numbering, audit, quick create, and search** enabled on all custom tables.
- **Packaged security role** (`Software Asset Manager User`) with the privileges needed to run the app.
- **Model-driven app** with forms (including a System tab), lookup views, and sub-grids for related records.

## Components

| Component | Type | Purpose |
|---|---|---|
| Software Asset Management | Model-driven app + sitemap | The app users open; navigation across all tables. |
| Vendor | Custom table | Companies that supply software; links to a primary Contact. |
| Product | Custom table | Software products with SKU and price; related to a Vendor. |
| Inquiry | Custom table | A purchasing action with POP dates, business justification, and a rolled-up total cost. |
| Inquiry Product | Custom table | Line items joining an Inquiry to Products, with quantity, per-line POC, and extended price. |
| Inquiry Process | Business Process Flow (+ backing table) | Guides each Inquiry through Draft → In Review → Award & Fulfillment. |
| Contact / User | OOTB tables | Referenced for vendor primary contacts and record ownership (POC, Requested By). |
| Inquiry - Sync Stage to Status | Real-time workflow | Keeps the Inquiry status reason aligned with the active BPF stage. |
| Inquiry - Milestone Timestamps | Cloud flow | Stamps stage completion dates as the Inquiry advances. |
| Inquiry - Review Decision Outcomes | Cloud flow | Applies reject / withdraw / return-for-rework results and resets the process. |
| Update Inquiry Total Cost | Cloud flow | Recalculates an Inquiry's total cost when line items change. |
| Web resources | JavaScript, HTML & images | BPF stage-gate script, total-cost recalculate button, and app icons. |
| Software Asset Manager User | Security role | Privileges required to use the app; assign alongside `Basic User`. |

## Installation

1. Download `SoftwareAssetManager.zip` from this folder.
2. In the [Power Platform maker portal](https://make.powerapps.com), select your target environment.
3. Go to **Solutions → Import solution**, choose the zip, and complete the wizard.
4. After import, assign users both the **Software Asset Manager User** role and the standard **Basic User** role.
5. Open the **Software Asset Management** app to get started.

> This is an **unmanaged** solution intended as a demo and starting point for customization. Import it into a development environment.

## Notes

- Built and validated in a **GCC (US Gov)** environment; it uses only standard Dataverse capabilities and works in commercial and government clouds.
