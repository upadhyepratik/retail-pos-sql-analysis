### Power BI KPI Reconciliation — Complete

Validated the six Power BI KPI measures against independent PostgreSQL queries on `public.superstore_clean`.

| KPI | PostgreSQL result | Validation |
|---|---:|---|
| Total Sales | 2,297,200.86 | Pass |
| Total Profit | 286,397.02 | Pass |
| Profit Margin | 12.47% | Pass |
| Distinct Orders | 5,009 | Pass |
| Distinct Customers | 793 | Pass |
| Average Order Value | 458.61 | Pass |

**Result:** All six tested KPI values matched their SQL baselines.

**Limitation:** This validates the KPI values under the tested report context. It does not independently verify every visual, filter interaction, or calculation in the report.

**Status:** Core KPI reconciliation complete.