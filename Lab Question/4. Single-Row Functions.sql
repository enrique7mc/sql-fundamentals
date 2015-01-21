SELECT product_name, catalog_url,
	SUBSTR(catalog_url, 17, 6) supplier
FROM product_information
WHERE LOWER(product_description) LIKE '%color%' AND
	  LOWER(product_description) LIKE '%printer%';