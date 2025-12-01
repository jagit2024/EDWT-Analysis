"""
=====================================================
FILE: generate_ed_data.py
PURPOSE: Generate synthetic ED visit data for analytics demo
OUTPUT: ed_visits_synthetic.csv (300 records)
EXECUTION: Run this FIRST before loading to SQL
=====================================================
"""

import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random
import os

# Set seed for reproducibility
np.random.seed(42)
random.seed(42)

# Number of records to generate
n = 300

print("Generating synthetic ED visit data...")

# Generate data
data = {
    'patient_id': [f'PT{i:04d}' for i in range(1, n+1)],
    
    'arrival_time': [
        datetime(2024, 11, 1) + timedelta(
            days=random.randint(0, 18),
            hours=random.randint(0, 23),
            minutes=random.randint(0, 59)
        ) for _ in range(n)
    ],
    
    'acuity_level': np.random.choice(
        [1, 2, 3, 4, 5], 
        n, 
        p=[0.05, 0.15, 0.35, 0.30, 0.15]
    ),
    
    'age_group': np.random.choice(
        ['0-17', '18-34', '35-54', '55-74', '75+'],
        n,
        p=[0.10, 0.25, 0.30, 0.25, 0.10]
    ),
    
    'chief_complaint': np.random.choice([
        'Chest Pain',
        'Abdominal Pain',
        'Shortness of Breath',
        'Injury/Trauma',
        'Headache',
        'Fever',
        'Back Pain',
        'Nausea/Vomiting',
        'Dizziness'
    ], n),
    
    'wait_time_minutes': [random.randint(5, 180) for _ in range(n)],
    
    'length_of_stay_hours': [round(random.uniform(0.5, 8.0), 2) for _ in range(n)]
}

# Create DataFrame
df = pd.DataFrame(data)

# Sort by arrival time
df = df.sort_values('arrival_time').reset_index(drop=True)

# Save to CSV
output_file = 'ed_visits_synthetic.csv'
df.to_csv(output_file, index=False)

print(f"Generated {len(df)} synthetic ED visits")
print(f"Saved to: {output_file}")
print(f"Location: {os.getcwd()}")
print("\nFirst 5 rows:")
print(df.head())
print("\nData Summary:")
print(df.describe())
print("\nData generation complete! Ready to load into SQL Server.")
