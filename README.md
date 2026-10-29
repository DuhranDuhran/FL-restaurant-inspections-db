# Florida Restaurant Inspections vs. Google Ratings — Database Design

A relational database designed to answer one question:

> **Do restaurants with great online reviews actually pass their health inspections?**

The schema combines Florida DBPR (Department of Business and Professional Regulation) restaurant inspection records with Google ratings, so establishments whose public reputation doesn't match their inspection history can be flagged and tracked over time.

## My role

This was a group project for Relational Database Management and Design at Florida International University. I designed the database: the entity-relationship model, the relationships between entities, and the data types. `schema.sql` implements that design in Oracle.

## Entity-relationship diagram

![ERD](docs/erd.png)

## Schema overview

| Table | Purpose |
|---|---|
| `County` | Florida counties and their DBPR district |
| `Locations` | Physical addresses, each in one county |
| `Establishments` | Licensed food businesses, keyed by DBPR license number |
| `Inspections` | Each inspection visit: date, type, outcome, and violation total |
| `Violation_Type` | Lookup of DBPR violation codes and their priority level |
| `Violation` | Individual violations cited during an inspection |
| `Google_Ratings` | Google rating data linked to an establishment |
| `Mismatch_Analysis` | Dated log of analysis results, flagging rating/inspection mismatches |

### Key relationships

- A **county** has many **locations** and many **establishments**.
- A **location** has many **establishments**.
- An **establishment** has many **inspections**; an **inspection** has many **violations**.
- Each **violation** references a **violation type**, which carries its priority level.
- **Google ratings** and **mismatch analysis** records each belong to one establishment.

## Design decisions

- **License number as the natural key.** DBPR identifies every food establishment by license number, so `Establishments` uses it as the primary key. That makes joining external data (inspections, ratings) straightforward.
- **Violation types as a lookup table.** Separating codes from individual violations keeps descriptions and priority levels in one place, so a priority can be reclassified once instead of in thousands of rows.
- **Priority level drives the analysis.** A restaurant with one high-priority violation is a different risk than one with five minor ones, so `Mismatch_Analysis` breaks counts out by priority rather than only storing a total.
- **Reporting-friendly tables.** `Google_Ratings` and `Mismatch_Analysis` keep business name and location fields alongside the license number, so analysis results can be read and exported without extra joins.
- **Mismatch analysis as a snapshot log.** `logged_date` lets the same establishment be evaluated repeatedly, showing whether a mismatch persists across inspection cycles.

## Running it

Runs on Oracle Database, including the free [Oracle Live SQL](https://livesql.oracle.com):

```sql
@schema.sql
```

## Repository structure

```
├── README.md
├── schema.sql      # Table definitions and keys
└── docs/
    └── erd.png     # Entity-relationship diagram
```

## Acknowledgments

Group project with [teammate names]. Data collection, queries, and analysis were done by other team members.
