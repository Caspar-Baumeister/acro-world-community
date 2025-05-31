#!/bin/bash

# Requires: curl, jq

# GeoNames config
USERNAME="acroworld"
FEATURE_CLASS="A"
ADM_LEVEL="ADM1"  # Change to ADM2 or ADM3 if needed

# Output file
OUTPUT_FILE="regions.json"

# Countries list (ISO codes)
COUNTRIES=("AU" "AT" "BE" "BG" "BR" "CA" "HR" "CY" "CZ" "DK" "EE" "FI" "FR" "DE" "GR" "HK" "HU" "IE" "IT" "JP" "LV" "LI" "LT" "LU" "MY" "MT" "MX" "NL" "NZ" "NG" "NO" "PL" "PT" "RO" "SG" "SK" "SI" "ZA" "ES" "SE" "CH" "TH" "AE" "GB" "US")

# Initialize result JSON
echo "{" > $OUTPUT_FILE

for CODE in "${COUNTRIES[@]}"; do
  echo "Fetching $CODE..."
  
  RESPONSE=$(curl -s "http://api.geonames.org/searchJSON?country=$CODE&featureClass=$FEATURE_CLASS&username=$USERNAME&maxRows=1000")
  
  # Extract names of regions matching ADM level
  REGIONS=$(echo "$RESPONSE" | jq -r --arg adm "$ADM_LEVEL" '.geonames[] | select(.fcode == $adm) | .name' | jq -R . | jq -s .)
  
  # Add to result JSON
  echo "  \"$CODE\": $REGIONS," >> $OUTPUT_FILE

  # Polite delay
  sleep 1
done

# Close JSON (remove last comma)
sed -i '' -e '$ s/,$//' $OUTPUT_FILE
echo "}" >> $OUTPUT_FILE

echo "✅ Done! Saved to $OUTPUT_FILE"
