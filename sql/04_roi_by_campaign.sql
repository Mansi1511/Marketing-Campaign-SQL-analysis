SELECT 
    c.campaign_id,
    c.channel,
    ROUND(SUM(oi.quantity * oi.discounted_price), 2) AS total_revenue,
    c.budget,
    ROUND(((SUM(oi.quantity * oi.discounted_price) - c.budget) / NULLIF(c.budget, 0)) * 100, 2) AS ROI_percentage
FROM campaigns c
JOIN orders o ON c.campaign_id = o.campaign_id
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN returns r ON oi.order_item_id = r.order_item_id
WHERE r.order_item_id IS NULL
GROUP BY c.campaign_id, c.channel, c.budget
ORDER BY ROI_percentage DESC;
