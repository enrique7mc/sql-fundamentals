--Chapter 2. Select Statement Lab Question

-- Excercise 1
DESC PRODUCT_INFORMATION;
DESC ORDERS;

-- Excercise 2
SELECT DISTINCT SALES_REP_ID
FROM ORDERS;
-- 9 differents reps

-- Exercise 3
SELECT ORDER_ID, ORDER_DATE, ORDER_TOTAL
FROM ORDERS;

-- Excercise 4
SELECT PRODUCT_NAME || ' with code: ' || PRODUCT_ID
|| ' has status of: ' || PRODUCT_STATUS AS "Product",
LIST_PRICE, MIN_PRICE, LIST_PRICE - MIN_PRICE AS "Max Actual Savings",
(LIST_PRICE - MIN_PRICE) / LIST_PRICE * 100 AS "Max Discount %"
FROM PRODUCT_INFORMATION;

-- Excercise 5
SELECT 4 * (22/7) * 3958.759 * 3958.759 AS "Earth's Area" FROM DUAL;