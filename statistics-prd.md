## Statistics PRD (Analytics Charts)

### Purpose
Define consistent, predictable rules for analytics charts (Page Views, Revenue, Bookings) with a unified x-axis labelling strategy, data aggregation, and visual behaviour across all time ranges.

### Global Rules
- X-axis labels are decoupled from the number of data points rendered.
  - We always render the full underlying time series (dense data points) for the selected period.
  - We render a limited, well-chosen set of x-axis tick labels only.
- Y-axis
  - Always starts at 0.
  - Show whole numbers only (no decimals).
  - If the maximum value is 0, use a default top value (e.g., 10) so the chart is well-formed.
- Zero-data periods: show 0 values for missing buckets; the line should run at y=0.
- Currency (Revenue): backend delivers cents; convert to major currency (divide by 100) before charting and formatting.
- Visual consistency: the same rules apply to all three analytics (Page Views, Revenue, Bookings).

### Time Periods

#### Today / Yesterday
- Underlying data points: 24 hours (hourly or finer if available; aggregated to the desired bucket internally).
- Aggregation buckets: 4-hour buckets.
- Tick labels (AM/PM):
  - 12 AM, 8 AM, 4 PM, 12 PM
- Behaviour: data bucket membership is based on the hour interval (e.g., 2:40 PM -> 12–4 PM bucket). The line renders using all buckets; labels show only the four ticks above.

#### Last 7 days
- Underlying data points: 7 daily data points (one per day).
- Tick labels: short weekday names ending with Today, e.g. Tue, Wed, Thu, Fri, Sat, Sun, Today.
- Behaviour: always show all 7 daily points; labels correspond to each day (7 ticks allowed here).

#### Last 30 days
- Underlying data points: 30 daily points (one per day; inclusive of today minus 29 days).
- Tick labels: 6 tick labels at 6-day steps ending with today. Example if today is 17 Sep: 18 Aug, 28 Aug, 7 Sep, 17 Sep (and include two more earlier ticks to total 6 when space allows). Format: "d MMM" (e.g., 7 Sep).
- Behaviour: chart computes and renders all 30 points; labels show only the 6 evenly spaced dates.

#### This month
- Underlying data points: 1 point per day in the current month.
- Tick labels: 1, 7, 14, 21, last day of month.
- Behaviour: render all daily points; show only the 5 ticks above.

#### This year
- Underlying data points: 12 monthly points (one per month).
- Tick labels: Jan, Apr, Jul, Oct, Dec (5 ticks).
- Behaviour: render 12 points; show 5 month ticks.

#### All time
- Underlying data points: 1 point per month since account creation (or 1 per year if monthly not feasible; choose consistent granularity system-wide).
- Tick labels: 4 year ticks from account creation year to current year (evenly spaced across the full extent). If fewer than 4 years exist, show available unique years.
- Behaviour: render the full historical series; show only 4 year ticks.

### Formatting
- Time labels (today/yesterday): AM/PM, e.g., 12 AM, 8 AM, 4 PM, 12 PM.
- Day labels (last 7 days): short weekdays (Mon, Tue, Wed, Thu, Fri, Sat, Sun) with Today for current day.
- Date labels (last 30 days): "d MMM" (e.g., 7 Sep).
- Month labels (this year): Jan, Feb, ... (for ticks only: Jan, Apr, Jul, Oct, Dec).
- Currency formatting: prefix with currency symbol, 2 decimals (e.g., €1,234.56). Values derived from cents.

### Data Aggregation Rules
- Bookings: count per bucket.
- Page Views: sum per bucket.
- Revenue: sum of amounts (major currency) per bucket.
- Bucketing follows the selected period’s bucket definition (hourly/4-hour, daily, monthly).

### Interaction with Labels vs Data Points
- The renderer must compute x positions for all data points based on a full, evenly spaced time scale for the selected period.
- The x-axis painter must compute tick positions independently (e.g., fixed indices for ticks) and draw only the configured labels.
- The scales (min/max time) must be consistent between data series and tick generation so points line up under the correct labels even when many labels are skipped.

### Edge Cases
- No data in range: show a flat line at 0 with the proper ticks.
- Partial months/years: daily/monthly series must respect actual days in month and current month/day.
- Timezone: use the user’s local timezone for bucketing and labels.

### Acceptance Criteria
1. For each time period, the x-axis shows exactly the labels specified above, and the rendered line uses the full dense series for that period.
2. Changing metrics (bookings, revenue, page views) does not change the x-axis labels for a selected period.
3. Revenue totals match backend values after cents-to-major conversion.
4. Y-axis starts at 0, shows only integers, and uses a default top > 0 when the series is all zeros.
5. Zero-data periods render a flat line at the bottom with correct ticks.

### Implementation Notes
- Create utilities to:
  - Generate dense time series ranges per period.
  - Map timestamps into bucket keys.
  - Produce tick definitions (label + index) independently of the dense series.
- Ensure the chart painter accepts both the dense data points and a separate list of tick labels with their relative positions.


