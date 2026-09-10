CREATE OR REPLACE VIEW vw_category_performance AS
SELECT
    order_category.product_category,
    SUM(order_category.units_sold) AS units_sold,
    COUNT(*) AS order_count,

    ROUND(
        SUM(order_category.product_revenue),
        2
    ) AS product_revenue,

    ROUND(
        SUM(order_category.freight_value),
        2
    ) AS freight_value,

    ROUND(
        SUM(order_category.order_category_value),
        2
    ) AS total_value,

    ROUND(
        AVG(order_category.order_category_value),
        2
    ) AS average_order_category_value,

    ROUND(
        100 * SUM(order_category.freight_value)
        / NULLIF(SUM(order_category.order_category_value), 0),
        2
    ) AS freight_percentage,

    ROUND(
        AVG(order_category.actual_delivery_days),
        2
    ) AS average_delivery_days,

    ROUND(
        100 * AVG(
            CASE
                WHEN order_category.is_late_delivery IS NOT NULL
                THEN order_category.is_late_delivery
            END
        ),
        2
    ) AS late_delivery_rate,

    ROUND(
        AVG(order_category.review_score),
        2
    ) AS average_review_score,

    ROUND(
        100 * AVG(
            CASE
                WHEN order_category.review_score IS NULL THEN NULL
                WHEN order_category.review_score <= 2 THEN 1
                ELSE 0
            END
        ),
        2
    ) AS low_review_rate

FROM (
    SELECT
        order_id,
        product_category,
        COUNT(*) AS units_sold,
        SUM(price) AS product_revenue,
        SUM(freight_value) AS freight_value,
        SUM(item_total_value) AS order_category_value,
        MAX(actual_delivery_days) AS actual_delivery_days,
        MAX(is_late_delivery) AS is_late_delivery,
        MAX(latest_review_score) AS review_score
    FROM fact_order_items
    WHERE order_status = 'delivered'
      AND product_category IS NOT NULL
    GROUP BY
        order_id,
        product_category
) AS order_category

GROUP BY order_category.product_category;
