-- Chapter 6. Reporting Aggregated Data Using the Group Functions
SELECT product_status, COUNT(*), SUM(list_price)
FROM product_information
WHERE product_status <> 'orderable'
GROUP BY product_status
HAVING SUM(list_price) > 4000;