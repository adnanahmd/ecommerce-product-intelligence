CREATE OR REPLACE VIEW vw_executive_summary AS
SELECT
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_unique_id) AS unique_customers,

    SUM(
        order_status = 'delivered'
    ) AS delivered_orders,

    ROUND(
        100 * SUM(order_status = 'delivered') / COUNT(*),
        2
    ) AS delivery_completion_rate,

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

    SUM(is_repeat_customer_order) AS repeat_orders,

    ROUND(
        100 * AVG(is_repeat_customer_order),
        2
    ) AS repeat_order_rate

FROM fact_orders;
