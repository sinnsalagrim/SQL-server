select top 10 * from CampaignData
select top 10 * from callbackconversion

------------- choose which offer to work on 
--- SABADSP
---
select cd.customerCampaignId, count(distinct os) as Os, count(distinct cd.[Source]) as Source, count(distinct pubid) as PubId, max(cd.trackingtime) endDate, min(cd.trackingtime) startDate from CampaignData cd with (NOLOCK)
                                            -- left join callbackconversion cc with (NOLOCK)
                                             --on cc.clickid = cd.clickid
                                             --where cc.conversiontime > '2018-02-10'
							group by cd.customerCampaignId 
							 
--- how much data on a campain - CR calculation
select cd.customerCampaignId, count(cc.ClickId) from callbackconversion cc with (NOLOCK)
                                             left join CampaignData cd with (NOLOCK)
                                             on cc.clickid = cd.clickid
                                             --where cc.conversiontime > '2018-02-10'
							group by cd.customerCampaignId

select customerCampaignId, count(ClickID) from CampaignData
group by customerCampaignId
                                     ---     where ClickId not in (select clickid from CallBackConversion) and trackingtime > '2018-02-10'
-------- decision tree queries

select cd.[source], pubid, TrackingTime, CustomerCampaignId ---campaign parameter
		---os, brand, model, cd.[ip],   ProvinceName, CityName --- user parameter
				from CampaignData cd
                                           left join callbackconversion cc
                                           on cc.clickid = cd.clickid
                                           where campaignId= 3

select cd.[source], pubid, TrackingTime, CustomerCampaignId
                                          from CampaignData
                                          where ClickId not in (select clickid from CallBackConversion) and campaignId= 3

--- affiliate network
select ov.offerid, ov.affiliatorid, ov.siteid, ov.OfferUrlId, ov.ClickId, os, brand, model, ov.Browser, ov.[IP], pubid, province, isp, ReferrerUrl, Pop, cc.SuccessReceive from offervisitor ov
                                           left join callbackconversion cc
                                           on cc.clickid = ov.clickid
                                           where cc.conversiontime > '2018-02-10'
select offerid, affiliatorid, siteid, OfferUrlId, ClickId, os, brand, model, Browser, [IP], pubid, province, isp, ReferrerUrl, Pop from offervisitor
                                        where ClickId not in (select clickid from CallBackConversion) and trackingtime > '2018-02-10'

--- (Offer loads, time) for day of week, hour, week, season, ...
select customercampaignid, [source], datepart(HOUR,TrackingTime), count(*) from campaigndata 
where TrackingTime > '2018-10-15'
group by customercampaignid, [source], datepart(HOUR,TrackingTime)

--- data for the deema - time,offer file in R
select customercampaignid, [source], datepart(WEEK,TrackingTime) Weeks, datepart(HOUR,TrackingTime) Hourss, count(*) Hits from campaigndata 
group by customercampaignid, [source], datepart(WEEK,TrackingTime), datepart(HOUR,TrackingTime)

select datepart(WEEK,TrackingTime) , datepart(MONTH,TrackingTime), count(1) from CampaignData
group by datepart(WEEK,TrackingTime) , datepart(MONTH,TrackingTime) 

--- provide data for knn
select TrackingTime, os, OsVersion, Brand, Model, ip, SiteId, Province, City, isp, ReferrerUrl, SuccessReceive from offervisitor o 
full join callbackconversion c
on o.clickid = c.clickid