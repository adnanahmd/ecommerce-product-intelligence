CREATE OR REPLACE VIEW vw_monthly_kpis AS
SELECT
    DATE_FORMAT(purchase_date, '%Y-%m-01') AS purchase_month,
    COUNT(*) AS total_orders,
    SUM(order_status = 'delivered') AS delivered_orders,

    ROUND(
        SUM(
            CASE
                WHEN order_status = 'delivered'
                THEN COALESCE(total_order_value, 0)
                ELSE 0
            END
        ),
        2
    ) AS delivered_revenue,

    ROUND(
        AVG(
            CASE
                WHEN order_status = 'delivered'
                THEN total_order_value
            END
        ),
        2
    ) AS average_order_value,

    ROUND(
        AVG(
            CASE
                WHEN order_status = 'delivered'
                THEN actual_delivery_days
            END
        ),
        2
    ) AS average_delivery_days,

    ROUND(
        100 * AVG(
            CASE
                WHEN order_status = 'delivered'
                     AND is_late_delivery IS NOT NULL
                THEN is_late_delivery
            END
        ),
        2
    ) AS late_delivery_rate,

    ROUND(
        AVG(
            CASE
                WHEN order_status = 'delivered'
                THEN latest_review_score
            END
        ),
        2
    ) AS average_review_score

FROM fact_orders
WHERE purchase_date IS NOT NULL
GROUP BY DATE_FORMAT(purchase_date, '%Y-%m-01');
