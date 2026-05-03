---
editor_options: 
  markdown: 
    wrap: 72
---

### Graph Explanation

### Glucose Distribution by Diagnosis

**x-axis**: **Diabetes Outcome**. It is categorized into two groups:
'Negative' (patients without a diabetes diagnosis) and 'Positive'
(patients diagnosed with diabetes).

**y-axis**: **Plasma Glucose Concentration** measured in mg/dL. It shows
the biological blood sugar levels of the patients in the dataset.

**What is the dot on the graph representing**: Each individual dot
(which makes up the jitter plot) represents a **single real patient**
from the study. We use "jittering" (slightly offsetting the dots
horizontally) to prevent them from stacking directly on top of each
other. This allows us to see the true volume, density, and distribution
of individual data points.

**White diamonds**: The white diamonds represent the **Arithmetic Mean
(average)** for each group after cleaning the data (removing biological
impossibilities like 0 glucose). \* For the Negative group, the mean is
**111 mg/dL**. \* For the Positive group, the mean is **142 mg/dL**.

### Gray zone:

The "Gray Zone" is the highlighted vertical overlap region between **100
and 140 mg/dL**. It shows the area where glucose values for both
Positive and Negative patients heavily overlap. In this zone, a glucose
reading alone is ambiguous, meaning it cannot definitively predict
whether a patient has diabetes or not.

-   **Low-Glucose Positives**: These are the dots found at the lower
    tail of the 'Positive' (red) group. They represent patients who were
    diagnosed with diabetes despite having unexpectedly low or "normal"
    glucose levels (with some dropping as low as 78 mg/dL). This proves
    you can have diabetes without presenting high baseline blood sugar.

-   **High-Glucose Negatives**: These are the dots found at the upper
    peak of the 'Negative' (blue) group. They represent individuals who
    presented with very high glucose levels (reaching up to 197 mg/dL)
    but did **not** receive a diabetes diagnosis. This proves that a
    high glucose spike alone does not always guarantee the disease is
    present.
