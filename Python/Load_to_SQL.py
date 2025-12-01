"""
=====================================================
FILE: load_to_sql.py
PURPOSE: Load synthetic CSV data into SQL Server Bronze layer
DEPENDENCIES: 
  - ed_visits_synthetic.csv must exist
  - bronze_ed_visits table must be created in SQL Server
EXECUTION: Run AFTER generate_ed_data.py
=====================================================
"""

import pandas as pd
import pyodbc

# Read the CSV file
print("Reading CSV file...")
df = pd.read_csv('ed_visits_synthetic.csv')

# Clean the data
print("Cleaning data...")
df['patient_id'] = df['patient_id'].astype(str).str.strip()
df['arrival_time'] = pd.to_datetime(df['arrival_time'])
df['acuity_level'] = df['acuity_level'].astype(int)
df['age_group'] = df['age_group'].astype(str).str.strip()
df['chief_complaint'] = df['chief_complaint'].astype(str).str.strip()
df['wait_time_minutes'] = df['wait_time_minutes'].astype(int)
df['length_of_stay_hours'] = df['length_of_stay_hours'].astype(float)

print(f"Loaded and cleaned {len(df)} rows")
print("\nData types:")
print(df.dtypes)
print("\nFirst 3 rows:")
print(df.head(3))

# Connect to SQL Server
# UPDATE THIS CONNECTION STRING WITH YOUR SERVER NAME!
conn_string = (
    'DRIVER={SQL Server};'
    'SERVER=localhost;'  # Change to your server name if different
    'DATABASE=ED_Analytics;'
    'Trusted_Connection=yes;'
)

try:
    print("\nConnecting to SQL Server...")
    conn = pyodbc.connect(conn_string)
    cursor = conn.cursor()
    
    print("Clearing existing data from Bronze table...")
    cursor.execute("TRUNCATE TABLE bronze_ed_visits")
    
    print("Inserting cleaned data into Bronze layer...")
    insert_query = """
    INSERT INTO bronze_ed_visits 
    (patient_id, arrival_time, acuity_level, age_group, chief_complaint, 
     wait_time_minutes, length_of_stay_hours)
    VALUES (?, ?, ?, ?, ?, ?, ?)
    """
    
    # Insert row by row
    for index, row in df.iterrows():
        cursor.execute(insert_query, 
                      str(row['patient_id']).strip(),
                      row['arrival_time'],
                      int(row['acuity_level']),
                      str(row['age_group']).strip(),
                      str(row['chief_complaint']).strip(),
                      int(row['wait_time_minutes']),
                      float(row['length_of_stay_hours']))
        
        # Progress indicator
        if (index + 1) % 50 == 0:
            print(f"  Inserted {index + 1} rows...")
    
    # Commit transaction
    conn.commit()
    print(f"\nSuccessfully loaded {len(df)} rows into bronze_ed_visits")
    
    # Verify load
    cursor.execute("SELECT COUNT(*) FROM bronze_ed_visits")
    count = cursor.fetchone()[0]
    print(f"Verified: {count} rows in database")
    
    # Show sample data
    print("\nSample data from Bronze layer:")
    cursor.execute("SELECT TOP 3 * FROM bronze_ed_visits")
    for row in cursor.fetchall():
        print(row)
    
    # Close connection
    cursor.close()
    conn.close()
    
    print("\nBronze layer load complete! Ready for Silver transformation.")
    
except Exception as e:
    print(f"Error: {e}")
    import traceback
    traceback.print_exc()
    print("\nTroubleshooting tips:")
    print("1. Verify SQL Server is running")
    print("2. Check server name (try 'localhost\\SQLEXPRESS' if on SQL Express)")
    print("3. Ensure bronze_ed_visits table exists")
    print("4. Confirm Windows Authentication is enabled")
