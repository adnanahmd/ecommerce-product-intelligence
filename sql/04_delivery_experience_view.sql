CREATE OR REPLACE VIEW vw_delivery_experience AS
SELECT
    CASE
        WHEN days_from_estimate <= -8 THEN '8+ days early'
        WHEN days_from_estimate <= -1 THEN '1–7 days early'
        WHEN days_from_estimate <= 1 THEN 'On schedule'
        WHEN days_from_estimate <= 3 THEN '1–3 days late'
        WHEN days_from_estimate <= 7 THEN '4–7 days late'
        ELSE '8+ days late'
    END AS delivery_timing,

    CASE
        WHEN days_from_estimate <= -8 THEN 1
        WHEN days_from_estimate <= -1 THEN 2
        WHEN days_from_estimate <= 1 THEN 3
        WHEN days_from_estimate <= 3 THEN 4
        WHEN days_from_estimate <= 7 THEN 5
        ELSE 6
    END AS delivery_timing_order,

    COUNT(*) AS delivered_orders,

    ROUND(
        AVG(actual_delivery_days),
        2
    ) AS average_delivery_days,

    ROUND(
        AVG(days_from_estimate),
        2
    ) AS average_days_from_estimate,

    ROUND(
        AVG(latest_review_score),
        2
    ) AS average_review_score,

    ROUND(
        100 * AVG(
            CASE
                WHEN latest_review_score IS NULL THEN NULL
                WHEN latest_review_score <= 2 THEN 1
                ELSE 0
            END
        ),
        2
    ) AS low_review_rate,

    ROUND(
        100 * AVG(
            CASE
                WHEN latest_review_score IS NULL THEN NULL
                WHEN latest_review_score = 5 THEN 1
                ELSE 0
            END
        ),
        2
    ) AS five_star_review_rate,

    ROUND(
        AVG(total_order_value),
        2
    ) AS average_order_value

FROM fact_orders
WHERE order_status = 'delivered'
  AND days_from_estimate IS NOT NULL

GROUP BY
    delivery_timing,
    delivery_timing_order;
