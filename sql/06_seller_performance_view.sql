CREATE OR REPLACE VIEW vw_seller_performance AS
SELECT
    order_seller.seller_id,
    MAX(order_seller.seller_city) AS seller_city,
    MAX(order_seller.seller_state) AS seller_state,

    COUNT(*) AS shipment_count,
    COUNT(DISTINCT order_seller.order_id) AS order_count,

    ROUND(
        SUM(order_seller.product_revenue),
        2
    ) AS product_revenue,

    ROUND(
        SUM(order_seller.freight_value),
        2
    ) AS freight_value,

    ROUND(
        SUM(order_seller.shipment_value),
        2
    ) AS total_value,

    ROUND(
        AVG(order_seller.shipment_value),
        2
    ) AS average_shipment_value,

    ROUND(
        100 * SUM(order_seller.freight_value)
        / NULLIF(SUM(order_seller.shipment_value), 0),
        2
    ) AS freight_percentage,

    ROUND(
        AVG(order_seller.distance_km),
        2
    ) AS average_distance_km,

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
        MAX(seller_city) AS seller_city,
        MAX(seller_state) AS seller_state,
        SUM(price) AS product_revenue,
        SUM(freight_value) AS freight_value,
        SUM(item_total_value) AS shipment_value,
        MAX(seller_customer_distance_km) AS distance_km,
        MAX(actual_delivery_days) AS actual_delivery_days,
        MAX(is_late_delivery) AS is_late_delivery,
        MAX(latest_review_score) AS review_score
    FROM fact_order_items
    WHERE order_status = 'delivered'
    GROUP BY
        order_id,
        seller_id
) AS order_seller

GROUP BY order_seller.seller_id;
