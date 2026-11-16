import pandas as pd
import numpy as np

def calculate_fpo_lead_score(row):
    score = 0
    if row.get('has_npop_organic_cert', 0) == 1:
        score += 25
    if row.get('is_apeda_cluster', 0) == 1:
        score += 15
    yt = row.get('district_yield_tier', 'Low')
    if yt == 'High':
        score += 30
    elif yt == 'Moderate':
        score += 15
    else:
        score += 5
    m = row.get('member_count', 0)
    if m >= 500:
        score += 20
    elif m >= 200:
        score += 10
    else:
        score += 5
    if row.get('has_cbbo_support', 0) == 1:
        score += 10
    return score

def assign_outreach_tier(score):
    if score >= 85:
        return 'Tier 1: High Priority (Immediate Outreach)'
    elif score >= 70:
        return 'Tier 2: Medium Priority (Mid-Term Onboarding)'
    else:
        return 'Tier 3: Secondary Priority (Agronomic Nurturing)'

def run_pipeline(input_csv='data/fpo_marketplace_raw.csv', output_csv='data/fpo_lead_scoring_master.csv'):
    print(f"Ingesting raw FPO dataset from '{input_csv}'...")
    df = pd.read_csv(input_csv)
    print("Executing 100-Point Lead-Scoring Engine...")
    df['composite_score'] = df.apply(calculate_fpo_lead_score, axis=1)
    df['outreach_tier'] = df['composite_score'].apply(assign_outreach_tier)
    df['total_cultivated_area_ha'] = (df['member_count'] * df['avg_holding_ha_per_member']).round(2)
    df['estimated_annual_production_tonnes'] = (df['total_cultivated_area_ha'] * df['district_yield_tonnes_per_ha']).round(2)
    df['estimated_gross_turnover_inr'] = (df['estimated_annual_production_tonnes'] * df['crop_realization_inr_per_tonne']).round(2)
    df_sorted = df.sort_values(by='composite_score', ascending=False).reset_index(drop=True)
    df_sorted.to_csv(output_csv, index=False)
    print(f"Lead Scoring Master exported successfully to '{output_csv}'!")

if __name__ == '__main__':
    run_pipeline()
