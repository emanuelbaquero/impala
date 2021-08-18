SELECT *
 FROM ( SELECT * 
          FROM awardnomination 
         WHERE Winner LIKE 'True') tabla 
WHERE ID > 5793
 AND lower(Category) like "%best%score%" ;