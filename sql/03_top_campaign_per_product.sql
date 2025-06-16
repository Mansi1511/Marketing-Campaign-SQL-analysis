SELECT 
    ranked.product_id,
    p.product_name,
    ranked.campaign_id,
    c.channel,
    ranked.revenue
FROM (
    SELECT 
        oi.product_id,
        o.campaign_id,
        SUM(oi.quantity * oi.discounted_price) AS revenue,
        ROW_NUMBER() OVER (PARTITION BY oi.product_id ORDER BY SUM(oi.quantity * oi.discounted_price) DESC) AS rnk
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    LEFT JOIN returns r ON oi.order_item_id = r.order_item_id
    WHERE r.order_item_id IS NULL
    GROUP BY oi.product_id, o.campaign_id
) AS ranked
JOIN campaigns c ON ranked.campaign_id = c.campaign_id
JOIN products p ON ranked.product_id = p.product_id
WHERE ranked.rnk = 1
ORDER BY revenue DESC;
