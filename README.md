# Nigeria Conflict Events: SQL and Power BI Analysis

An analysis of recorded conflict events and best fatality estimates in Nigeria from 1990 to 2025. The project uses SQL to explore the data and an interactive Power BI report to present the findings.

## Project objective

Explore how recorded conflict events and best fatality estimates vary over time, across violence types and conflict labels, and by location in Nigeria.

## Tools used

- **Power Query** to filter the Africa-wide source dataset to Nigeria.
- **Excel** to review and correct event start and end dates.
- **MySQL Workbench and SQL** to organize and analyze the data.
- **Power BI** to create an interactive report with charts, summary cards, and slicers.

## Data preparation

The source UCDP Georeferenced Event Dataset (GED), version 26.1, covered countries across Africa. I used Power Query to select the Nigeria records for this project.

I reviewed the selected data and corrected event start and end dates, checking the updates against event IDs. In MySQL, I organized the data into related event, conflict, participant, location, and violence-type tables.

## Analysis

The SQL analysis examined:

- Recorded events and best fatality estimates by year.
- Events and best fatality estimates by violence type and conflict label.
- Locations with higher recorded event counts and fatality estimates.
- The share of the overall best fatality estimate represented by the ten highest-estimate events.
- Event duration using the corrected start and end dates.

The Power BI report presents the results across three areas: an overview of events and fatalities, conflict profiles, and geographic patterns.

## Key findings

- The analysis includes **3,487 recorded events** and a total **best fatality estimate of 28,709**.
- State-based conflict accounts for approximately **85.9%** of the best fatality estimate in the violence-type comparison; one-sided violence accounts for approximately **14.1%**.
- The **“Nigeria: Islamic State”** conflict label has the highest event count, with **1,798 events**. The **“Nigeria: Government”** label has the highest best fatality estimate among the labels, at **12,363**.
- Borno State has the largest state-level best fatality estimate shown in the analysis, at **20,520**.
- The ten events with the highest best fatality estimates account for **5,004**, or about **17.43%**, of the overall estimate.
- Following the date corrections, **557 events** span more than one calendar date, while **2,930** have the same start and end date.
- The annual charts show an increase in recorded event activity in later years, with event-count peaks around 2020 and 2023. The fatality-estimate chart shows a prominent peak around 2014–2015.

## Recommendations

- Review locations with high estimates alongside current humanitarian, displacement, health, and security information.
- Consider event frequency and estimated severity separately; they do not always rank locations or conflict labels in the same order.
- Review high-estimate events and their context before making claims about responsibility or causes.
- Document data filters, corrections, and query definitions so the analysis can be reproduced and updated.

## Limitations

UCDP best fatality estimates represent the most likely event-level estimates; they are not exact totals. Conflict labels are dataset classifications and should not be treated as definitive attribution of responsibility. This is descriptive analysis and does not establish the causes of conflict patterns. Results may also be affected by missing location information and report filters.

## Data source

[UCDP Dataset Download Center](https://ucdp.uu.se/downloads/)

## Project files

- **Power BI report (.pbix):** Interactive dashboard of events, fatalities, conflict profiles, and geographic patterns.
- **SQL script (.sql):** Queries used to analyze the data.
- **Excel preparation workbook (.xlsx):** Workbook used during data review and preparation.
- **Cleaned Nigeria dataset (.csv):** Nigeria records prepared for the analysis.
- **Dashboard screenshots:** Previews of the report pages are shown above.

## Dashboard previews

![Overview](./Overview%20record.JPG)

![Conflict profile](./Conflict%20Profile.JPG)

![Geographical distribution](./Geographical%20distribution.JPG)
