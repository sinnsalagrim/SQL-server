----------- extracting domain from URL
SELECT 
    SUBSTRING(ReferrerUrl,
        (CASE WHEN CHARINDEX('//', ReferrerUrl)= 0 THEN 1 ELSE CHARINDEX('//', ReferrerUrl) + 2 END),
        CASE
            WHEN CHARINDEX('/', ReferrerUrl, CHARINDEX('//', ReferrerUrl) + 2) > 0 THEN CHARINDEX('/', ReferrerUrl, CHARINDEX('//', ReferrerUrl) + 2) - (CASE WHEN CHARINDEX('//', ReferrerUrl)= 0 THEN 1 ELSE CHARINDEX('//', ReferrerUrl) + 2 END)
            WHEN CHARINDEX('?', ReferrerUrl, CHARINDEX('//', ReferrerUrl) + 2) > 0 THEN CHARINDEX('?', ReferrerUrl, CHARINDEX('//', ReferrerUrl) + 2) - (CASE WHEN CHARINDEX('//', ReferrerUrl)= 0 THEN 1 ELSE CHARINDEX('//', ReferrerUrl) + 2 END)
            ELSE LEN(ReferrerUrl)
        END
    ) AS 'ReferrerUrl' from OfferVisitor

---------- 
select 
CASE
	WHEN Pop NOT IN ('Popup1', 'Popup2')
	THEN 'Popup2' ELSE Pop
END
from OfferVisitor
