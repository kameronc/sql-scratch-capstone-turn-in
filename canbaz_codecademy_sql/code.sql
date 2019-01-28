-- Quiz Funnel

SSELECT *
FROM survey
LIMIT 10;


-- Using GROUP BY

SELECT question, COUNT(user_id) AS 'num_users'
FROM survey
GROUP BY 1;


-- Home Try-On Funnel

SELECT *
FROM quiz
LIMIT 5;

SELECT *
FROM home_try_on
LIMIT 5;

SELECT *
FROM purchase
LIMIT 5;


-- New table

SELECT DISTINCT q.user_id,
  CASE
    WHEN h.user_id IS NOT NULL
    THEN 'True'
    ELSE 'False'
  END AS 'is_home_try_on’,
  h.number_of_pairs,
  CASE
    WHEN p.user_id IS NOT NULL
    THEN 'True'
    ELSE 'False'
  END AS 'is_purchase'
FROM quiz AS 'q'
LEFT JOIN home_try_on AS 'h'
	ON h.user_id = q.user_id
LEFT JOIN purchase AS 'p'
	ON p.user_id = h.user_id
LIMIT 10;


-- Additional Analysis #1

WITH funnel AS (
  SELECT DISTINCT q.user_id,
    h.user_id IS NOT NULL AS 'is_home_try_on’,
    h.number_of_pairs,
    p.user_id IS NOT NULL as 'is_purchase'
  FROM quiz AS 'q'
  LEFT JOIN home_try_on AS 'h'
    ON h.user_id = q.user_id
  LEFT JOIN purchase AS 'p’
    ON p.user_id = h.user_id
)

SELECT COUNT(*) AS 'num_users',
  SUM(is_home_try_on) AS 'num_home_try_on',
  SUM(is_purchase) AS 'num_purchase',
  (1.0 * SUM(is_home_try_on) / COUNT(user_id)) AS 'prct_home_try_on',
  (1.0 * SUM(is_purchase) / SUM(is_home_try_on)) AS 'prct_purchase'
FROM funnel;



-- Additional Analysis #2

WITH funnel AS (
  SELECT DISTINCT q.user_id,
    h.user_id IS NOT NULL AS 'is_home_try_on’,
    h.number_of_pairs,
    p.user_id IS NOT NULL as 'is_purchase'
  FROM quiz AS 'q'
  LEFT JOIN home_try_on AS 'h'
    ON h.user_id = q.user_id
  LEFT JOIN purchase AS 'p’
    ON p.user_id = h.user_id
)

SELECT COUNT(*) AS 'num_users',
  SUM(is_home_try_on) AS 'num_home_try_on',
  SUM(is_purchase) AS 'num_purchase',
  (1.0 * SUM(is_home_try_on) / COUNT(user_id)) AS 'prct_home_try_on',
  (1.0 * SUM(is_purchase) / SUM(is_home_try_on)) AS 'prct_purchase'
FROM funnel
GROUP BY number_of_pairs;
