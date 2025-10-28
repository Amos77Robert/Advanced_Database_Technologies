# Intelligence Databases - Debugging SQL codes

## Project Overview
This folder contains solutions for Intelligent Databases topic whose assignment concepts including debugging the declarative constraints, active databases, deductive databases, knowledge bases, and spatial databases. All implementations are built using **Oracle 21c Enterprise Edition**.  
The folder consists of PDF file for the report and SQL files bearing the name of each question of the assignment  

---

## Assignment Solutions

### 1) Rules (Declarative Constraints): Safe Prescriptions
**Objective**: Implement declarative constraints as the database's first line of defense for prescription validation.

**Features**:
- Non-negative dosing constraints
- Mandatory field enforcement
- Referential integrity to PATIENT table
- Sensible date logic (start date not after end date)
- Compiling table definition that rejects bad rows at insert time

**Files**: `safe-prescriptions.sql`

### 2) Active Databases (E-C-A Trigger): Bill Totals That Stay Correct
**Objective**: Practice Event-Condition-Action logic to maintain derived totals automatically using statement-level triggers.

**Features**:
- Statement-level trigger `TRG_BILL_TOTAL_STMT`
- Avoids mutating-table issues
- Single computation per bill ID
- Audit trail in `BILL_AUDIT` table
- Handles INSERT/UPDATE/DELETE operations efficiently

**Files**: `bill-totals-trigger.sql`

### 3) Deductive Databases (Recursive WITH): Referral/Supervision Chain
**Objective**: Use recursive subquery factoring to derive supervision hierarchies from atomic facts.

**Features**:
- Computes employee's top supervisor and hop count
- Gracefully handles cycles in supervision chains
- Proper join directions and hop counter implementation
- Cycle detection using Oracle's built-in CYCLE clause

**Files**: `supervision-hierarchy.sql`

### 4) Knowledge Bases (Triples & Ontology): Infectious-Disease Roll-Up
**Objective**: Demonstrate ontology-aware querying using triples and transitive closure.

**Features**:
- Triple store implementation with subject-predicate-object model
- Transitive closure computation for 'isA' relationships
- Patient diagnosis classification using ontology hierarchy
- Fixed directionality errors in recursive queries

**Files**: `triple-store-ontology.sql`

### 5) Spatial Databases (Geography & Distance): Radius & Nearest-3
**Objective**: Apply spatial reasoning for clinic location queries using Oracle Spatial.

**Features**:
- Clinic locations stored with proper WGS84 SRID (4326)
- Spatial indexing for performance optimization
- Radius queries within 1 km distance
- Nearest-neighbor queries with distance calculations
- Correct coordinate order (longitude, latitude) and unit specifications

**Files**: `spatial-queries.sql`

---

## Technical Implementation Details

### Database Environment
- **Database**: Oracle 21c Enterprise Edition
- **Spatial Extension**: Oracle Spatial for geographic queries
- **Constraints**: Comprehensive CHECK constraints and referential integrity
- **Triggers**: Compound and statement-level triggers for derived data maintenance

### Key Technologies Used
- **Recursive CTEs** for hierarchical queries
- **Spatial Indexing** for geographic searches
- **Declarative Constraints** for data integrity
- **ECA Triggers** for automatic data consistency
- **Triple Stores** for ontological reasoning

---

## Academic Disclaimer  
- All data used in this database design and implementation is dummy data created solely to facilitate validation of the technical implementations. This includes names, contact numbers, locations, and email addresses - none represent real individuals or actual hospital records.
