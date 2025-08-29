-- 1. Total Number of Projects based on Outcome

SELECT 
    state AS Outcome, COUNT(*) AS Total_Projects
FROM
    projects
GROUP BY state
ORDER BY Total_Projects DESC;

-- 2. Total Number of Projects based on Locations

SELECT 
    l.displayable_name AS Location,
    COUNT(p.ProjectID) AS Total_Projects
FROM
    projects p
        JOIN
    location_sql l ON p.location_id = l.id
GROUP BY l.displayable_name
ORDER BY Total_Projects DESC;

-- 3. Total Number of Projects based on  Category

SELECT 
    c.name AS Category, COUNT(p.ProjectID) AS Total_Projects
FROM
    projects p
        JOIN
    category_sql c ON p.category_id = c.id
GROUP BY c.name
ORDER BY Total_Projects DESC;

-- 4. Total Number of Projects created by Year , Quarter , Month

-- Projects per Year 

SELECT 
    EXTRACT(YEAR FROM FROM_UNIXTIME(created_at)) AS Year,
    COUNT(ProjectID) AS Total_Projects
FROM
    projects
GROUP BY Year
ORDER BY Year;

-- Projects per Quarter

SELECT 
    EXTRACT(YEAR FROM FROM_UNIXTIME(created_at)) AS Year,
    EXTRACT(QUARTER FROM FROM_UNIXTIME(created_at)) AS Quarter,
    COUNT(ProjectID) AS Total_Projects
FROM
    projects
GROUP BY Year , Quarter
ORDER BY Year , Quarter;

-- Projects per Month

SELECT 
    EXTRACT(YEAR FROM FROM_UNIXTIME(created_at)) AS Year,
    EXTRACT(MONTH FROM FROM_UNIXTIME(created_at)) AS Month,
    COUNT(ProjectID) AS Total_Projects
FROM
    projects
GROUP BY Year , Month
ORDER BY Year , Month;


SELECT 
    EXTRACT(YEAR FROM FROM_UNIXTIME(created_at)) AS Year,
    EXTRACT(QUARTER FROM FROM_UNIXTIME(created_at)) AS Quarter,
    EXTRACT(MONTH FROM FROM_UNIXTIME(created_at)) AS Month,
    COUNT(ProjectID) AS Total_Projects
FROM
    projects
GROUP BY Year , Quarter , Month
ORDER BY Year , Quarter , Month;

-- 6. Successful Projects

SELECT 
    state, COUNT(ProjectID) AS Total_Projects
FROM
    projects
WHERE
    state = "successful"
GROUP BY state;

-- 7. Amount Raised 

SELECT 
    SUM(COALESCE(usd_pledged, pledged * static_usd_rate)) AS Total_Amount_Raised_USD
FROM 
projects ;
    
-- 8. Number of Backers

SELECT 
    SUM(backers_count) AS Total_Backers
FROM
    projects;
    
-- 9. Avg Number of Days for successful projects

SELECT 
    AVG(DATEDIFF(FROM_UNIXTIME(deadline),
            FROM_UNIXTIME(launched_at))) AS Avg_Days_Successful_Projects
FROM
    projects
WHERE
    state = "successful";
    
-- 10. Top Successful Projects Based on Number of Backers

SELECT 
    name AS Project_Name, backers_count
FROM
    projects
WHERE
    state = "successful"
ORDER BY backers_count DESC
LIMIT 10;

-- 11. Top Successful Projects Based on Amount Raised

SELECT 
    name AS Project_Name, pledged AS Amount_Raised
FROM
    projects
WHERE
    state = "successful"
ORDER BY pledged DESC
LIMIT 10;

-- 12. Percentage of Successful Projects overall

SELECT 
    (COUNT(CASE WHEN state = "successful" THEN 1 END) * 100.0) / COUNT(*) 
    AS Success_Percentage,
    (COUNT(CASE WHEN state = "canceled" THEN 1 END) * 100.0) / COUNT(*) 
    AS Canceled_Percentage,
     (COUNT(CASE WHEN state = "failed" THEN 1 END) * 100.0) / COUNT(*) 
    AS Failed_Percentage,
     (COUNT(CASE WHEN state = "live" THEN 1 END) * 100.0) / COUNT(*) 
    AS Live_Percentage,
     (COUNT(CASE WHEN state = "purged" THEN 1 END) * 100.0) / COUNT(*) 
    AS Purged_Percentage,
     (COUNT(CASE WHEN state = "suspended" THEN 1 END) * 100.0) / COUNT(*) 
    AS Suspended_Percentage
FROM 
    projects;
    
-- 13. Percentage of Successful Projects  by Category

SELECT 
    c.name AS Category,
    (COUNT(CASE
        WHEN p.state = "successful" THEN 1
    END) * 100.0) / COUNT(*) AS Success_Percentage
FROM
    projects p
        JOIN
    category_sql c ON p.category_id = c.id
GROUP BY c.name
ORDER BY Success_Percentage DESC;

-- 14. Percentage of Successful Projects by Year ,Quarter, Month

SELECT 
    YEAR(FROM_UNIXTIME(launched_at)) AS Year,
    QUARTER(FROM_UNIXTIME(launched_at)) AS Quarter,
    MONTH(FROM_UNIXTIME(launched_at)) AS Month,
    (COUNT(CASE
        WHEN state = "successful" THEN 1
    END) * 100.0) / COUNT(*) AS Success_Percentage
FROM
    projects
GROUP BY Year , Quarter , Month
ORDER BY Year , Quarter , Month;

-- 15. Percentage of Successful projects by Goal Range

SELECT 
    CASE
        WHEN goal BETWEEN 0 AND 999 THEN "Below 1K"
        WHEN goal BETWEEN 1000 AND 4999 THEN "1K - 5K"
        WHEN goal BETWEEN 5000 AND 9999 THEN "5K - 10K"
        WHEN goal BETWEEN 10000 AND 49999 THEN "10K - 50K"
        WHEN goal BETWEEN 50000 AND 99999 THEN "50K - 100K"
        ELSE "100K+"
    END AS Goal_Range,
    ROUND((COUNT(CASE
                WHEN state = "successful" THEN 1
            END) * 100.0) / NULLIF(COUNT(*), 0),
            2) AS Success_Percentage
FROM
    projects
GROUP BY Goal_Range
ORDER BY MIN(goal);

-- 16. Projects that raised more money than the average amount pledged across all projects. 

SELECT 
    ProjectID,
    name,
    pledged
FROM 
    projects
WHERE 
    pledged > (SELECT AVG(pledged) FROM projects);


-- 17. top 3 categories with the highest total pledged amount. 

WITH CategoryTotals AS (
    SELECT 
        category_id,
        SUM(pledged) AS Total_Pledged
    FROM 
        projects
    GROUP BY 
        category_id
)
SELECT 
    category_id,
    Total_Pledged
FROM 
    CategoryTotals
ORDER BY 
    Total_Pledged DESC
LIMIT 3;











    
    
    


    
    
    
    
    


    
    
    








     

    



    








