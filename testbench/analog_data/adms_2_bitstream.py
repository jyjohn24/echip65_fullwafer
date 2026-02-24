import pandas as pd
import numpy as np

# Generated using AI model claude-sonnet-high
# Configuration - matches ADMS SDM clock
SDM_CLK_PERIOD_NS = 195.312  # 5.12 MHz
INPUT_FILE = 'modulator_output_dig.csv'
OUTPUT_FILE = 'sd_bitstream.txt'

# Read the file and find where .DATA starts
with open(INPUT_FILE, 'r') as f:
    lines = f.readlines()

# Find the .DATA line
data_start = 0
for i, line in enumerate(lines):
    if line.strip() == '.DATA':
        data_start = i + 1
        break

if data_start == 0:
    print("ERROR: Could not find .DATA section in file")
    exit(1)

print(f"Data starts at line {data_start}")

# Read CSV starting from data section
df = pd.read_csv(INPUT_FILE, skiprows=data_start, header=None, names=['Time', 'Value'])

# Clean up the data
df['Time'] = df['Time'].astype(float)
df['Value'] = df['Value'].str.strip().str.strip("'").astype(int)

print(f"Read {len(df)} data points from ADMS file")
print(f"Time range: {df['Time'].min()*1e6:.2f} to {df['Time'].max()*1e6:.2f} us")

# Create time vector at SDM clock rate
clk_period = SDM_CLK_PERIOD_NS * 1e-9
max_time = df['Time'].max()
num_samples = int(max_time / clk_period) + 1

print(f"\nSDM Clock period: {SDM_CLK_PERIOD_NS} ns ({1e9/SDM_CLK_PERIOD_NS:.2f} MHz)")
print(f"Number of SDM clock cycles: {num_samples}")

# Sample at each SDM clock edge
sampled_bits = []
df_idx = 0

for i in range(num_samples):
    t = i * clk_period
    
    # Find the last value at or before this time
    while df_idx < len(df) - 1 and df['Time'].iloc[df_idx + 1] <= t:
        df_idx += 1
    
    sampled_bits.append(str(df['Value'].iloc[df_idx]))

# Write to file (one bit per line)
with open(OUTPUT_FILE, 'w') as f:
    f.write('\n'.join(sampled_bits))

print(f"\nWritten {len(sampled_bits)} samples to {OUTPUT_FILE}")
print(f"First 50 bits: {''.join(sampled_bits[:50])}")

# Calculate some statistics
ones_count = sum([1 for b in sampled_bits if b == '1'])
zeros_count = len(sampled_bits) - ones_count
print(f"\nBit statistics:")
print(f"  Ones:  {ones_count} ({100*ones_count/len(sampled_bits):.1f}%)")
print(f"  Zeros: {zeros_count} ({100*zeros_count/len(sampled_bits):.1f}%)")