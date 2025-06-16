SELECT 
    ranked.campaign_id,
    c.channel,
    p.product_name,
    ranked.product_revenue
FROM (
    SELECT 
        o.campaign_id,
        oi.product_id,
        SUM(oi.quantity * oi.discounted_price) AS product_revenue,
        RANK() OVER (PARTITION BY o.campaign_id ORDER BY SUM(oi.quantity * oi.discounted_price) DESC) AS rnk
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    LEFT JOIN returns r ON oi.order_item_id = r.order_item_id
    WHERE r.order_item_id IS NULL
    GROUP BY o.campaign_id, oi.product_id
) AS ranked
JOIN campaigns c ON ranked.campaign_id = c.campaign_id
JOIN products p ON ranked.product_id = p.product_id
WHERE ranked.rnk = 1
ORDER BY ranked.product_revenue DESC;
