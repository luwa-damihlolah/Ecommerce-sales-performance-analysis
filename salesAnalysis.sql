WITH cte AS (
    SELECT
        PD.Category,
        PD.Product,
        PD.Brand,
        PD.`Sale Price`,
        PD.`Cost Price`,
        PD.Description,
        PD.`Image url`,
        PS.Date,
        PS.`Customer Type`,
        PS.`Discount Band`,
        PS.Country,
        PS.`Units Sold`,

        CAST(REPLACE(PD.`Cost Price`, '$', '') AS DECIMAL(10,2))
            * CAST(PS.`Units Sold` AS DECIMAL(10,2)) AS Total_cost,

        CAST(REPLACE(PD.`Sale Price`, '$', '') AS DECIMAL(10,2))
            * CAST(PS.`Units Sold` AS DECIMAL(10,2)) AS Revenue,

        DATE_FORMAT(STR_TO_DATE(PS.Date, '%e/%c/%Y'), '%M') AS month,
        DATE_FORMAT(STR_TO_DATE(PS.Date, '%e/%c/%Y'), '%Y') AS year

    FROM product_data PD
    JOIN product_sales PS
        ON PD.`Product _ID` = PS.Product
)
SELECT
 *,
 (1-Discount*1.0/100)*Revenue as Discount_revenue
FROM cte CT
JOIN discount_data DD
    ON LOWER(TRIM(CT.`Discount Band`)) = LOWER(TRIM(DD.`Discount Band`))
   AND LOWER(TRIM(CT.month)) = LOWER(TRIM(DD.Month))