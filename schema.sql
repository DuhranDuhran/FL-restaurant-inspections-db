-- =====================================================================
-- Florida Restaurant Inspections vs. Google Ratings
-- Database schema (Oracle)
--
-- Compares Florida DBPR restaurant inspection results with Google
-- ratings to flag establishments whose public reputation doesn't match
-- their inspection record.
-- =====================================================================

CREATE TABLE County (
  county_id      NUMBER,
  county_name    VARCHAR2(100),
  dbpr_district  VARCHAR2(50),
  state          CHAR(2),
  CONSTRAINT pk_county PRIMARY KEY (county_id)
);

CREATE TABLE Locations (
  location_id     NUMBER,
  county_id       NUMBER,
  license_no      VARCHAR2(20),
  street_address  VARCHAR2(200),
  city            VARCHAR2(100),
  zip_code        CHAR(5),
  county_name     VARCHAR2(100),
  CONSTRAINT pk_locations PRIMARY KEY (location_id),
  CONSTRAINT fk_locations_county FOREIGN KEY (county_id)
    REFERENCES County (county_id)
);

CREATE TABLE Establishments (
  license_no     VARCHAR2(20),
  location_id    NUMBER,
  county_id      NUMBER,
  business_name  VARCHAR2(100),
  license_type   VARCHAR2(100),
  CONSTRAINT pk_establishments PRIMARY KEY (license_no),
  CONSTRAINT fk_estab_location FOREIGN KEY (location_id)
    REFERENCES Locations (location_id),
  CONSTRAINT fk_estab_county FOREIGN KEY (county_id)
    REFERENCES County (county_id)
);

CREATE TABLE Google_Ratings (
  rating_id      NUMBER,
  license_no     VARCHAR2(20),
  business_name  VARCHAR(200),
  zip_code       CHAR(5),
  city           VARCHAR2(100),
  county_name    VARCHAR2(100),
  review_count   NUMBER,
  rating_label   VARCHAR2(50),
  last_updated   DATE,
  CONSTRAINT pk_google_ratings PRIMARY KEY (rating_id),
  CONSTRAINT fk_rating_estab FOREIGN KEY (license_no)
    REFERENCES Establishments (license_no)
);

CREATE TABLE Inspections (
  inspection_id     NUMBER,
  license_no        VARCHAR2(20),
  visit_date        DATE,
  visit_type        VARCHAR2(100),
  disposition       VARCHAR2(100),
  total_violations  NUMBER,
  CONSTRAINT pk_inspections PRIMARY KEY (inspection_id),
  CONSTRAINT fk_insp_estab FOREIGN KEY (license_no)
    REFERENCES Establishments (license_no)
);

CREATE TABLE Violation_Type (
  viol_code       VARCHAR2(10),
  description     VARCHAR2(500),
  priority_level  VARCHAR2(50),
  CONSTRAINT pk_violation_type PRIMARY KEY (viol_code)
);

CREATE TABLE Violation (
  violation_id      NUMBER,
  inspection_id     NUMBER,
  viol_code         VARCHAR2(10),
  corrected_onsite  VARCHAR2(10),
  CONSTRAINT pk_violation PRIMARY KEY (violation_id),
  CONSTRAINT fk_viol_inspection FOREIGN KEY (inspection_id)
    REFERENCES Inspections (inspection_id),
  CONSTRAINT fk_viol_type FOREIGN KEY (viol_code)
    REFERENCES Violation_Type (viol_code)
);

CREATE TABLE Mismatch_Analysis (
  mismatch_id           NUMBER,
  license_no            VARCHAR2(20),
  business_name         VARCHAR2(200),
  zip_code              CHAR(5),
  city                  VARCHAR2(100),
  rating_label          VARCHAR2(50),
  total_violations      NUMBER,
  high_priority_count   NUMBER,
  intermediate_count    NUMBER,
  last_inspection_date  DATE,
  mismatch_flag         VARCHAR2(20),
  logged_date           DATE,
  CONSTRAINT pk_mismatch_analysis PRIMARY KEY (mismatch_id),
  CONSTRAINT fk_mismatch_estab FOREIGN KEY (license_no)
    REFERENCES Establishments (license_no)
);
