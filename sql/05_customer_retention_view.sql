CREATE OR REPLACE VIEW vw_customer_retention AS
SELECT
    CASE
        WHEN customer_summary.total_orders = 1
        THEN 'One-time customers'
        ELSE 'Repeat customers'
    END AS customer_segment,

    COUNT(*) AS customer_count,
    SUM(customer_summary.total_orders) AS total_orders,

    ROUND(
        AVG(customer_summary.total_orders),
        2
    ) AS average_orders_per_customer,

    SUM(
        customer_summary.delivered_orders
    ) AS delivered_orders,

    ROUND(
        SUM(customer_summary.delivered_revenue),
        2
    ) AS delivered_revenue,

    ROUND(
        AVG(customer_summary.delivered_revenue),
        2
    ) AS average_customer_revenue,

    ROUND(
        SUM(customer_summary.delivered_revenue)
        / NULLIF(SUM(customer_summary.delivered_orders), 0),
        2
    ) AS average_order_value,

    ROUND(
        100 * SUM(customer_summary.late_delivery_count)
        / NULLIF(SUM(customer_summary.evaluated_deliveries), 0),
        2
    ) AS late_delivery_rate,

    ROUND(
        SUM(customer_summary.review_score_total)
        / NULLIF(SUM(customer_summary.reviewed_orders), 0),
        2
    ) AS average_review_score,

    ROUND(
        AVG(
            DATEDIFF(
                customer_summary.latest_purchase_date,
                customer_summary.first_purchase_date
            )
        ),
        2
    ) AS average_customer_span_days

FROM (
    SELECT
        customer_unique_id,
        COUNT(*) AS total_orders,

        SUM(
            order_status = 'delivered'
        ) AS delivered_orders,

        SUM(
            CASE
                WHEN order_status = 'delivered'
                THEN COALESCE(total_order_value, 0)
                ELSE 0
            END
        ) AS delivered_revenue,

        SUM(
            CASE
                WHEN order_status = 'delivered'
                     AND is_late_delivery IS NOT NULL
                THEN is_late_delivery
                ELSE 0
            END
        ) AS late_delivery_count,

        SUM(
            CASE
                WHEN order_status = 'delivered'
                     AND is_late_delivery IS NOT NULL
                THEN 1
                ELSE 0
            END
        ) AS evaluated_deliveries,

        SUM(
            CASE
                WHEN order_status = 'delivered'
                     AND latest_review_score IS NOT NULL
                THEN latest_review_score
                ELSE 0
            END
        ) AS review_score_total,

        SUM(
            CASE
                WHEN order_status = 'delivered'
                     AND latest_review_score IS NOT NULL
                THEN 1
                ELSE 0
            END
        ) AS reviewed_orders,

        MIN(purchase_date) AS first_purchase_date,
        MAX(purchase_date) AS latest_purchase_date

    FROM fact_orders
    WHERE customer_unique_id IS NOT NULL
    GROUP BY customer_unique_id
) AS customer_summary

GROUP BY customer_segment;
