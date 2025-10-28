# Parallel and Distributed Databases - Lab Assignment
---

## 📁 Assignment Overview

This folder contains assignment 3. It is a complete implementation and documentation for the **Parallel and Distributed Databases Lab Assignment**. The project demonstrates practical implementation of distributed database concepts using Oracle Database, focusing on fragmentation, distributed transactions, parallel processing, and concurrency control.

---

## 🎯 Assignment Objectives

This lab assessment measures students' ability to:
- Design and implement a parallel and distributed database system using Oracle
- Execute real-world scenarios based on existing project schemas
- Analyze performance, concurrency, and recovery in distributed environments

---

## 📋 Practical Tasks Implementation

### Task 1: Distributed Schema Design and Fragmentation
**Implementation:** Horizontal fragmentation of hospital database into two logical nodes:
- `c##bugesera_branch` - Neurology department data
- `c##kigali_branch` - All other departments data

**Files:** `those starting with Qtn_1`

### Task 2: Database Links Creation and Usage
**Implementation:** Created `KIGALI_BRANCH_LINK` database link with successful remote SELECT operations and distributed joins.

**Files:** `those starting with Qtn_2`

### Task 3: Parallel Query Execution
**Implementation:** Enabled parallel query execution on large tables with performance comparison between serial and parallel execution using `/*+ PARALLEL */` hints.

**Files:** `those starting with Qtn_3`

### Task 4: Two-Phase Commit Simulation
**Implementation:** PL/SQL block performing atomic inserts across both nodes with verification using `DBA_2PC_PENDING` data dictionary view.

**Files:** `those starting with Qtn_4`

### Task 5: Distributed Rollback and Recovery
**Implementation:** Simulated network failure during distributed transactions and demonstrated recovery using `ROLLBACK FORCE` command.

**SQL Files:** `those starting with Qtn_5`

### Task 6: Distributed Concurrency Control
**Implementation:** Demonstrated lock conflicts between sessions from different nodes with analysis using `DBA_LOCKS` and interpretation of locking behavior.

**SQL Files:** `those starting with Qtn_6`

### Task 7: Parallel Data Loading / ETL Simulation
**Implementation:** Parallel data aggregation and loading using PARALLEL DML with runtime comparison and performance improvement documentation.

**SQL Files:** `those starting with Qtn_7`

### Task 8: Three-Tier Client-Server Architecture Design
**Implementation:** Designed and documented three-tier architecture showing data flow between Presentation, Application, and Database layers with database link interactions.

**SQL Files:** `those starting with Qtn_8`

### Task 9: Distributed Query Optimization
**Implementation:** Used `EXPLAIN PLAN` and `DBMS_XPLAN.DISPLAY` to analyze distributed joins, discussing optimizer strategies and data movement minimization.

**SQL Files:** `those starting with Qtn_9`

### Task 10: Performance Benchmark and Report
**Implementation:** Complex query executed in centralized, parallel, and distributed modes with performance measurement using `AUTOTRACE` and scalability analysis.

**SQL Files:** `those starting with Qtn_10`

---

## Academic Disclaimer
- 
## Academic Disclaimer
-All data used in this database design and implementation is dummy data created solely to facilitate validation of the technical implementations. This includes names, contact numbers, locations, and email addresses - none represent real individuals or actual hospital records.
