SELECT 
    c.campaign_id,
    c.channel,
    ROUND(SUM(oi.discounted_price * oi.quantity), 2) AS net_revenue
FROM campaigns c
JOIN orders o ON c.campaign_id = o.campaign_id
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN returns r ON oi.order_item_id = r.order_item_id
WHERE r.order_item_id IS NULL
GROUP BY c.campaign_id, c.channel
ORDER BY net_revenue DESC;
