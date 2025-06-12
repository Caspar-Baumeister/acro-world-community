#!/bin/bash

# Requires: curl, jq

# GeoNames config
USERNAME="acroworld"
FEATURE_CLASS="A"
ADM_LEVEL="ADM1"  # Change to ADM2 or ADM3 if needed

# Output file
OUTPUT_FILE="regions.json"

# Countries list (ISO codes)
COUNTRIES=(
  "AF" "AL" "DZ" "AD" "AO" "AI" "AG" "AR" "AM" "AW"
  "AU" "AT" "AZ" "BS" "BH" "BD" "BB" "BY" "BE" "BZ"
  "BJ" "BM" "BT" "BO" "BA" "BW" "BR" "BN" "BG" "BF"
  "BI" "CV" "KH" "CM" "CA" "KY" "CF" "TD" "CL" "CN"
  "CO" "KM" "CR" "HR" "CU" "CW" "CY" "CZ" "CI" "CD"
  "DK" "DJ" "DM" "DO" "EC" "EG" "SV" "GQ" "ER" "EE"
  "SZ" "ET" "FK" "FO" "FM" "FJ" "FI" "FR" "GA" "GM"
  "GE" "DE" "GH" "GI" "GR" "GL" "GD" "GP" "GT" "GG"
  "GN" "GW" "GY" "HT" "VA" "HN" "HK" "HU" "IS" "IN"
  "ID" "IR" "IQ" "IE" "IM" "IL" "IT" "JM" "JP" "JE"
  "JO" "KZ" "KE" "KI" "XK" "KW" "KG" "LA" "LV" "LB"
  "LS" "LR" "LY" "LI" "LT" "LU" "MO" "MG" "MW" "MY"
  "MV" "ML" "MT" "MH" "MR" "MU" "YT" "MX" "MD" "MC"
  "MN" "ME" "MS" "MA" "MZ" "MM" "NA" "NR" "NP" "NL"
  "NZ" "NI" "NE" "NG" "NU" "NF" "KP" "MK" "MP" "NO"
  "OM" "PK" "PW" "PA" "PG" "PY" "PE" "PH" "PN" "PL"
  "PT" "QA" "CG" "RO" "RU" "RW" "BL" "SH" "KN" "LC"
  "MF" "PM" "VC" "WS" "SM" "ST" "SA" "SC" "SL" "SG"
  "SX" "SK" "SI" "SB" "SO" "ZA" "GS" "KR" "SS" "ES"
  "LK" "PS" "SD" "SR" "SJ" "SE" "CH" "SY" "TW" "TJ"
  "TZ" "TH" "TL" "TG" "TK" "TO" "TT" "TN" "TM" "TC"
  "TV" "TR" "UG" "UA" "AE" "GB" "US" "UY" "UZ" "VU"
  "VE" "VN" "VG" "WF" "EH" "YE" "ZM" "ZW"
)
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
