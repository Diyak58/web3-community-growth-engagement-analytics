CREATE DATABASE web3_community_analytics;

CREATE TABLE users (
    user_id VARCHAR(10) PRIMARY KEY,
    join_date DATE,
    source VARCHAR(50),
    country VARCHAR(50),
    wallet_connected VARCHAR(5)
);

SELECT COUNT(*) AS total_users
FROM users;

CREATE TABLE activities (
    activity_id VARCHAR(10) PRIMARY KEY,
    user_id VARCHAR(10),
    activity_date DATE,
    activity_type VARCHAR(50),
    points_earned INT
);


SELECT COUNT(*) AS total_activities
FROM activities;


CREATE TABLE campaigns (
    campaign_id VARCHAR(10) PRIMARY KEY,
    campaign_name VARCHAR(100),
    start_date DATE,
    spend_usd INT,
    end_date DATE
);


SELECT COUNT(*) AS total_campaigns
FROM campaigns;


CREATE TABLE user_campaigns (
    user_id VARCHAR(10),
    campaign_id VARCHAR(10)
);


SELECT COUNT(*) AS total_user_campaigns
FROM user_campaigns;


SELECT COUNT(*) AS total_users
FROM users;

SELECT 
    source,
    COUNT(*) AS total_users
FROM users
GROUP BY source
ORDER BY total_users DESC;

SELECT
    DATE_FORMAT(join_date, '%Y-%m') AS month,
    COUNT(*) AS new_users
FROM users
GROUP BY month
ORDER BY month;

SELECT
    month,
    new_users,
    SUM(new_users) OVER (ORDER BY month) AS cumulative_users
FROM (
    SELECT
        DATE_FORMAT(join_date, '%Y-%m') AS month,
        COUNT(*) AS new_users
    FROM users
    GROUP BY month
) t;

SELECT
    user_id,
    COUNT(*) AS total_activities
FROM activities
GROUP BY user_id
ORDER BY total_activities DESC
LIMIT 10;

SELECT
    activity_date,
    COUNT(DISTINCT user_id) AS daily_active_users
FROM activities
GROUP BY activity_date
ORDER BY activity_date;

SELECT
    DATE_FORMAT(activity_date, '%Y-%m') AS month,
    COUNT(DISTINCT user_id) AS monthly_active_users
FROM activities
GROUP BY month
ORDER BY month;

SELECT
    activity_type,
    COUNT(*) AS total_activities
FROM activities
GROUP BY activity_type
ORDER BY total_activities DESC;

SELECT
    activity_type,
    ROUND(AVG(points_earned),2) AS avg_points
FROM activities
GROUP BY activity_type
ORDER BY avg_points DESC;

SELECT
    c.campaign_name,
    COUNT(DISTINCT uc.user_id) AS users_reached
FROM campaigns c
JOIN user_campaigns uc
    ON c.campaign_id = uc.campaign_id
GROUP BY c.campaign_name
ORDER BY users_reached DESC;

SELECT
    c.campaign_name,
    COUNT(DISTINCT uc.user_id) AS users_reached,
    ROUND(
        COUNT(DISTINCT uc.user_id) * 100.0 /
        (SELECT COUNT(*) FROM users),
        2
    ) AS engagement_rate_pct
FROM campaigns c
JOIN user_campaigns uc
    ON c.campaign_id = uc.campaign_id
GROUP BY c.campaign_name
ORDER BY engagement_rate_pct DESC;

SELECT
    country,
    COUNT(*) AS total_users
FROM users
GROUP BY country
ORDER BY total_users DESC;

SELECT
    wallet_connected,
    COUNT(*) AS total_users,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM users),
        2
    ) AS percentage
FROM users
GROUP BY wallet_connected;

SELECT
    DATE_FORMAT(join_date, '%Y-%m') AS join_month,
    COUNT(*) AS users_joined
FROM users
GROUP BY join_month
ORDER BY join_month;

SELECT
    DATE_FORMAT(activity_date, '%Y-%m') AS month,
    COUNT(*) AS total_activities
FROM activities
GROUP BY month
ORDER BY month;


SELECT
    source,
    COUNT(*) AS total_users,
    SUM(CASE WHEN wallet_connected = 'Yes' THEN 1 ELSE 0 END) AS wallet_users,
    ROUND(
        SUM(CASE WHEN wallet_connected = 'Yes' THEN 1 ELSE 0 END) * 100.0 /
        COUNT(*),
        2
    ) AS wallet_adoption_pct
FROM users
GROUP BY source
ORDER BY wallet_adoption_pct DESC;


SELECT
    c.campaign_name,
    ROUND(AVG(a.points_earned),2) AS avg_points
FROM campaigns c
JOIN user_campaigns uc
    ON c.campaign_id = uc.campaign_id
JOIN activities a
    ON uc.user_id = a.user_id
GROUP BY c.campaign_name
ORDER BY avg_points DESC;