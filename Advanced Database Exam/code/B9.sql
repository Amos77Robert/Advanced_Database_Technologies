-- ============================================================
-- B9_1: CREATE TRIPLE TABLE FOR KNOWLEDGE BASE
-- ============================================================
-- Purpose: Store subject-predicate-object facts for medical ontology
-- ============================================================

CREATE TABLE TRIPLE (
    s VARCHAR2(64),  -- Subject
    p VARCHAR2(64),  -- Predicate  
    o VARCHAR2(64)   -- Object
);

-- ============================================================
-- B9_2: INSERT MEDICAL ONTOLOGY FACTS (8 ROWS)
-- ============================================================
-- Purpose: Create type hierarchy for medical conditions and treatments
-- ============================================================

-- Medical condition type hierarchy
INSERT INTO TRIPLE VALUES ('Influenza', 'isA', 'ViralInfection');
INSERT INTO TRIPLE VALUES ('CommonCold', 'isA', 'ViralInfection');
INSERT INTO TRIPLE VALUES ('ViralInfection', 'isA', 'InfectiousDisease');
INSERT INTO TRIPLE VALUES ('BacterialPneumonia', 'isA', 'InfectiousDisease');

-- Treatment relationships
INSERT INTO TRIPLE VALUES ('Paracetamol', 'treats', 'Fever');
INSERT INTO TRIPLE VALUES ('Antiviral', 'treats', 'ViralInfection');
INSERT INTO TRIPLE VALUES ('Antibiotic', 'treats', 'BacterialInfection');
INSERT INTO TRIPLE VALUES ('BacterialPneumonia', 'isA', 'BacterialInfection');

COMMIT;

select * from triple;  -- shwo triple inserted content

-- ============================================================
-- B9_3: RECURSIVE INFERENCE QUERY
-- ============================================================
-- Purpose: Implement transitive closure for isA* relationships
-- ============================================================

WITH INFERRED_TYPES (child, ancestor) AS (
    -- Anchor: Direct isA relationships
    SELECT s, o 
    FROM TRIPLE 
    WHERE p = 'isA'
    
    UNION ALL
    
    -- Recursive: Transitive isA* relationships
    SELECT t.s, i.ancestor
    FROM TRIPLE t
    JOIN INFERRED_TYPES i ON t.o = i.child
    WHERE t.p = 'isA'
)
SELECT DISTINCT
    t.s as CONDITION,
    LISTAGG(i.ancestor, ', ') WITHIN GROUP (ORDER BY i.ancestor) as INFERRED_TYPES
FROM TRIPLE t
JOIN INFERRED_TYPES i ON t.s = i.child
WHERE t.p = 'isA'
GROUP BY t.s
ORDER BY t.s;

-- ============================================================
-- B9: GROUPING COUNTS FOR CONSISTENCY PROOF
-- ============================================================
-- Purpose: Verify inferred labels are consistent across the hierarchy
-- ============================================================

WITH INFERRED_TYPES AS (
    SELECT s, o FROM TRIPLE WHERE p = 'isA'
    UNION ALL
    SELECT t.s, i.o
    FROM TRIPLE t
    JOIN INFERRED_TYPES i ON t.o = i.s
    WHERE t.p = 'isA'
)
SELECT 
    i.o as INFERRED_CATEGORY,
    COUNT(DISTINCT i.s) as CONDITION_COUNT,
    LISTAGG(i.s, ', ') WITHIN GROUP (ORDER BY i.s) as CONDITIONS
FROM INFERRED_TYPES i
GROUP BY i.o
ORDER BY CONDITION_COUNT DESC;

-- ============================================================
-- B9: RECURSIVE INFERENCE QUERY (FIXED WITH COLUMN ALIASES)
-- ============================================================
-- Purpose: Implement transitive closure for isA* relationships with proper column aliases
-- ============================================================

WITH INFERRED_TYPES (child, ancestor) AS (  -- COLUMN ALIASES ADDED HERE
    -- Anchor: Direct isA relationships
    SELECT s, o 
    FROM TRIPLE 
    WHERE p = 'isA'
    
    UNION ALL
    
    -- Recursive: Transitive isA* relationships
    SELECT t.s, i.ancestor
    FROM TRIPLE t
    JOIN INFERRED_TYPES i ON t.o = i.child
    WHERE t.p = 'isA'
)
SELECT DISTINCT
    t.s as CONDITION,
    LISTAGG(i.ancestor, ', ') WITHIN GROUP (ORDER BY i.ancestor) as INFERRED_TYPES
FROM TRIPLE t
JOIN INFERRED_TYPES i ON t.s = i.child
WHERE t.p = 'isA'
GROUP BY t.s
ORDER BY t.s;


-- ============================================================
-- B9_4: GROUPING COUNTS FOR CONSISTENCY PROOF 
-- ============================================================
-- Purpose: Verify inferred labels are consistent across the hierarchy
-- ============================================================

WITH INFERRED_TYPES (subject, category) AS (  -- COLUMN ALIASES ADDED
    SELECT s, o FROM TRIPLE WHERE p = 'isA'
    UNION ALL
    SELECT t.s, i.category
    FROM TRIPLE t
    JOIN INFERRED_TYPES i ON t.o = i.subject
    WHERE t.p = 'isA'
)
SELECT 
    i.category as INFERRED_CATEGORY,
    COUNT(DISTINCT i.subject) as CONDITION_COUNT,
    LISTAGG(i.subject, ', ') WITHIN GROUP (ORDER BY i.subject) as CONDITIONS
FROM INFERRED_TYPES i
GROUP BY i.category
ORDER BY CONDITION_COUNT DESC;
