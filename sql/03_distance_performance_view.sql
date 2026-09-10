CREATE OR REPLACE VIEW vw_distance_performance AS
SELECT
    CASE
        WHEN order_seller.distance_km < 100 THEN '0–99 km'
        WHEN order_seller.distance_km < 300 THEN '100–299 km'
        WHEN order_seller.distance_km < 600 THEN '300–599 km'
        WHEN order_seller.distance_km < 1000 THEN '600–999 km'
        WHEN order_seller.distance_km < 1500 THEN '1,000–1,499 km'
        ELSE '1,500+ km'
    END AS distance_band,

    CASE
        WHEN order_seller.distance_km < 100 THEN 1
        WHEN order_seller.distance_km < 300 THEN 2
        WHEN order_seller.distance_km < 600 THEN 3
        WHEN order_seller.distance_km < 1000 THEN 4
        WHEN order_seller.distance_km < 1500 THEN 5
        ELSE 6
    END AS distance_band_order,

    COUNT(*) AS shipment_count,
    COUNT(DISTINCT order_seller.order_id) AS order_count,
    COUNT(DISTINCT order_seller.seller_id) AS seller_count,

    ROUND(
        AVG(order_seller.distance_km),
        2
    ) AS average_distance_km,

    ROUND(
        SUM(order_seller.shipment_value),
        2
    ) AS total_value,

    ROUND(
        AVG(order_seller.freight_value),
        2
    ) AS average_freight_value,

    ROUND(
        100 * SUM(order_seller.freight_value)
        / NULLIF(SUM(order_seller.shipment_value), 0),
        2
    ) AS freight_percentage,

    ROUND(
        AVG(order_seller.actual_delivery_days),
        2
    ) AS average_delivery_days,

    ROUND(
        100 * AVG(order_seller.is_late_delivery),
        2
    ) AS late_delivery_rate,

    ROUND(
        AVG(order_seller.review_score),
        2
    ) AS average_review_score,

    ROUND(
        100 * AVG(
            CASE
                WHEN order_seller.review_score IS NULL THEN NULL
                WHEN order_seller.review_score <= 2 THEN 1
                ELSE 0
            END
        ),
        2
    ) AS low_review_rate

FROM (
    SELECT
        order_id,
        seller_id,
        MAX(seller_customer_distance_km) AS distance_km,
        SUM(item_total_value) AS shipment_value,
        SUM(freight_value) AS freight_value,
        MAX(actual_delivery_days) AS actual_delivery_days,
        MAX(is_late_delivery) AS is_late_delivery,
        MAX(latest_review_score) AS review_score
    FROM fact_order_items
    WHERE order_status = 'delivered'
      AND seller_customer_distance_km IS NOT NULL
    GROUP BY
        order_id,
        seller_id
) AS order_seller

GROUP BY
    distance_band,
    distance_band_order;
