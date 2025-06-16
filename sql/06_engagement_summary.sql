SELECT 
    e.campaign_id,
    c.channel,
    COUNT(DISTINCT e.customer_id) AS unique_customers,
    COUNT(e.interaction_type) AS total_interactions
FROM engagements e
JOIN campaigns c ON e.campaign_id = c.campaign_id
GROUP BY e.campaign_id, c.channel
ORDER BY total_interactions DESC;
