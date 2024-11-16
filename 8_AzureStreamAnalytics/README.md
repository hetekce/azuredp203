# 8. Azure Stream Analytics

## 8.1. Windowing Functions

In Azure Stream Analytics, **windowing functions** are used to perform calculations over streaming data within specific time frames. Here's a quick summary:

1. **Tumbling Window**: Fixed-size, non-overlapping windows (e.g., 5-minute chunks). Each event is processed only once.

```sql
-- Calculate the average temperature and the number of readings every 5 minutes per device.
SELECT 
    deviceId, 
    AVG(temperature) AS AvgTemp, 
    COUNT(*) AS ReadingCount
FROM 
    SensorStream
GROUP BY 
    deviceId, 
    TumblingWindow(minute, 5)
```
   
2. **Hopping Window**: Overlapping windows with a fixed size and a hop interval (e.g., a 10-minute window that advances every 5 minutes).

```sql
-- Calculate the total sales and the number of transactions every 10 minutes, updated every 5 minutes.
SELECT 
    Region, 
    SUM(SaleAmount) AS TotalSales, 
    COUNT(*) AS TransactionCount
FROM 
    SalesStream
GROUP BY 
    Region, 
    HoppingWindow(minute, 10, 5)
```
   
3. **Sliding Window**: A window that starts when an event arrives and slides over time, adjusting dynamically to incoming events.

```sql
-- Monitor the maximum and minimum temperature over the last 10 minutes for each device, adjusting dynamically with each event.
SELECT 
    deviceId, 
    MAX(temperature) AS MaxTemp, 
    MIN(temperature) AS MinTemp
FROM 
    SensorStream
GROUP BY 
    deviceId, 
    SlidingWindow(minute, 10)
```
   
4. **Session Window**: Dynamic window based on periods of activity followed by a timeout. It groups events with gaps of inactivity.

```sql
-- Calculate the duration of user sessions and total actions taken during each session, with a 10-minute idle timeout indicating the end of a session.
SELECT 
    userId, 
    SUM(actionCount) AS TotalActions, 
    DATEDIFF(second, MIN(eventTime), MAX(eventTime)) AS SessionDuration
FROM 
    UserActivityStream
GROUP BY 
    userId, 
    SessionWindow(minute, 10)
```

5. **Snapshot Window**: It captures data **only when a specific event triggers it**, instead of over a time interval. It’s useful for getting a point-in-time view of data when a particular condition occurs.

```sql
-- Trigger a snapshot to get the total sales and average order value whenever a new order is completed.
SELECT 
    OrderId, 
    SUM(SaleAmount) AS TotalOrderValue, 
    AVG(SaleAmount) AS AvgOrderValue, 
    COUNT(*) AS ItemsInOrder
FROM 
    OrdersStream
WHERE 
    EventType = 'OrderCompleted'
GROUP BY 
    OrderId
```

These functions allow you to aggregate, analyze, and summarize data in real-time effectively.
[See](https://learn.microsoft.com/en-us/stream-analytics-query/windowing-azure-stream-analytics) about the windowing functions more.
