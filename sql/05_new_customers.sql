SELECT 
    o.customer_id,
    o.campaign_id,
    SUM(oi.quantity * oi.discounted_price) AS customer_revenue
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
LEFT JOIN returns r ON oi.order_item_id = r.order_item_id
WHERE r.order_item_id IS NULL
  AND o.customer_id IN (
      SELECT customer_id
      FROM orders
      GROUP BY customer_id
      HAVING MIN(order_date) = MAX(order_date)
  )
GROUP BY o.customer_id, o.campaign_id;
