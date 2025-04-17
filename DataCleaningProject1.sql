-- REMOVE DUPLICATES
-- STANDARIZING THE DATA
-- HANDLE NULL AND BLANK VALUES
-- REMOVE COLUMNS OR ROWS. 
-- EXPLORATORY DATA ANALYSIS 

SET SQL_SAFE_UPDATES = 0;
CREATE TABLE layoffs_staging
LIKE layoffs
;

INSERT layoffs_staging
SELECT *
FROM layoffs
;

SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry , total_laid_off, `date`, funds_raised_millions) AS row_num  
FROM layoffs_staging
;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry , total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num  
FROM layoffs_staging

) 

SELECT *
FROM duplicate_cte
WHERE row_num > 1
;

CREATE TABLE `layoffs_staging2` (
`company` text,
`location` text,
`industry` text,
`total_laid_off` int default null,
`percentage_laid_off` text,
`date` text,
`stage` text,
`country` text,
`funds_raised_millions` int default null,
`row_num` INT

) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 collate = utf8mb4_0900_ai_ci;

select * 
from layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER (
PARTITION BY company, location, industry , total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num  
FROM layoffs_staging
;

DELETE  
FROM layoffs_staging2
WHERE row_num > 1
;
# Standirizing data

UPDATE layoffs_staging2
SET company = trim(company);

UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

select distinct country, trim(trailing '.' from country)
from layoffs_staging2 
order by 1;

UPDATE layoffs_staging2
SET `date` = str_to_date(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_staging2
modify column `date` date;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_staging2
WHERE industry = '' OR industry IS NULL;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

DELETE
FROM layoffs_staging2
WHERE total_laid_off IS NULL AND percentage_laid_off IS NULL;

-- EXPLORATORY DATA ANALYSIS 

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;  

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;  

SELECT year(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY year(`date`)
ORDER BY 1 DESC;  



SELECT substring(`date`, 1, 7), sum(total_laid_off)
FROM layoffs_staging2
WHERE substring(`date`, 1, 7) is not null
GROUP BY substring(`date`, 1, 7)
ORDER BY 2 desc;

SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY company asc;

WITH Company_year(company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), sum(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)

)


SELECT *, dense_rank() over(partition by years order by total_laid_off desc) rank_comp
FROM Company_year
WHERE years is not null
ORDER BY rank_comp ; 

