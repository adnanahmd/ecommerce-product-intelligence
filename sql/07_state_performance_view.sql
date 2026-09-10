CREATE OR REPLACE VIEW vw_state_performance AS
SELECT
    customer_state,
    'Brazil' AS country,

    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,

    SUM(
        order_status = 'delivered'
    ) AS delivered_orders,

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
    ) AS average_review_score,

    ROUND(
        100 * AVG(is_repeat_customer_order),
        2
    ) AS repeat_order_rate,

    ROUND(
        AVG(customer_latitude),
        6
    ) AS average_latitude,

    ROUND(
        AVG(customer_longitude),
        6
    ) AS average_longitude

FROM fact_orders
WHERE customer_state IS NOT NULL
GROUP BY customer_state;
