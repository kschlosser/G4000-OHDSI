/* Find other drugs that contains Warfarin AND Dabigratran */
SELECT max_levels_of_separation, c.* 
FROM concept_ancestor ca, concept c 
WHERE ca.ancestor_concept_id = 1310149 /* Warfarin */
	AND ca.descendant_concept_id = c.concept_id 
ORDER BY max_levels_of_separation;

/*************************************************************************
* Warfarin New Users
*************************************************************************/

WITH CTE_DRUG_INDEX AS (
	SELECT de.PERSON_ID, MIN(de.DRUG_EXPOSURE_START_DATE) AS INDEX_DATE
	FROM DRUG_EXPOSURE de
	WHERE de.DRUG_CONCEPT_ID IN (
		SELECT DESCENDANT_CONCEPT_ID 
		FROM CONCEPT_ANCESTOR WHERE ANCESTOR_CONCEPT_ID = 1310149 /*warfarin*/
	)
	GROUP BY de.PERSON_ID
)
SELECT i.PERSON_ID, i.INDEX_DATE, 
       op.OBSERVATION_PERIOD_START_DATE, 
       op.OBSERVATION_PERIOD_END_DATE,
	(i.INDEX_DATE-op.OBSERVATION_PERIOD_START_DATE) AS DAYS_BEFORE_INDEX
FROM CTE_DRUG_INDEX i
JOIN OBSERVATION_PERIOD op
		ON op.PERSON_ID = i.PERSON_ID
		AND i.INDEX_DATE BETWEEN op.OBSERVATION_PERIOD_START_DATE 
AND op.OBSERVATION_PERIOD_END_DATE
WHERE (i.INDEX_DATE-op.OBSERVATION_PERIOD_START_DATE) >= 180
ORDER BY i.PERSON_ID


