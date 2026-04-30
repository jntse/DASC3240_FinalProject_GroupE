# PIMA Dataset Feature Guide

## Feature Summary Table

| Feature | Description | Type | Range | Missing |
|:--------|:------------|:-----|:------|:--------|
| **Pregnancies** | Number of times pregnant | Integer | 0-17 | ❌ No |
| **Glucose** | Plasma glucose (2h post OGTT) | Integer | 0-199 | ❌ No |
| **Blood Pressure** | Diastolic BP (mm Hg) | Integer | 0-122 | ✅ Yes (0) |
| **Skin Thickness** | Triceps fold (mm) | Integer | 0-99 | ✅ Yes (0) |
| **Insulin** | 2-Hour serum insulin | Integer | 0-846 | ✅ Yes (0) |
| **BMI** | Body mass index | Float | 0-67.1 | ❌ No |
| **Diabetes Pedigree** | Genetic risk score | Float | 0.078-2.42 | ❌ No |
| **Age** | Age in years | Integer | 21-81 | ❌ No |
| **Outcome** | Diabetes diagnosis | Binary | 0/1 | ❌ No |

---

## Detailed Feature Guide

<details>
<summary><b>Click to expand: Clinical Measurements</b></summary>

### Glucose
- **Normal**: < 100 mg/dL
- **Prediabetes**: 100-125 mg/dL  
- **Diabetes**: ≥ 126 mg/dL

### BMI Categories
- Underweight: < 18.5
- Normal: 18.5-24.9
- Overweight: 25-29.9
- Obese: ≥ 30

</details>

<details>
<summary><b>Click to expand: Missing Data Note</b></summary>

⚠️ **Critical**: Values of 0 in Blood Pressure, Skin Thickness, and Insulin indicate **missing data**, not actual measurements!

These should be handled using:
- Mean/median imputation
- KNN imputation
- Or removal if appropriate

</details>