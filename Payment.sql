select * from
(SELECT t.Msisdn,t.AppId,Count(*) AS 'Count' FROM TransactionResult tr
right JOIN [Transaction] t ON tr.TransactionId=t.Id
WHERE tr.Status=3  and cast(t.InsertDateTime as date) between '2016-10-01' and '2016-10-29' 
GROUP BY t.Msisdn,t.AppId having count(1)>29 ) A

left join

(select Msisdn, AppId, count(1) as 'count' from SubscriptionHistory
where IsActive = 1 and InsertDateTime between '2016-10-20' and '2016-10-21'
Group By Msisdn, AppId) B

On A.Msisdn = B.Msisdn and A.AppId = B.AppId
where A.Count > isnull(B.count,0) + 1

/* unsubscription from pannel */
select CAST(insertdatetime as date), appid, COUNT(1) from SubscriptionHistory
where Agent = 1 and CAST(insertdatetime as date) >= '2016-10-24'
group by CAST(insertdatetime as date), appid
order by CAST(insertdatetime as date)

/* double */
select * from
(SELECT Msisdn, AppId,Count(*) AS 'Count', max(insertdatetime) AS 'MAX' FROM TransactionArchive
WHERE InsertDateTime  between '2016-10-01' and '2016-10-28'  AND resultStatus=3 
GROUP BY Msisdn,AppId having count(1)>1 ) A

left join

(select Msisdn, AppId, count(1) as 'count' from SubscriptionHistory
where  InsertDateTime between '2016-10-01' and '2016-10-28'
Group By Msisdn, AppId) B

On A.Msisdn = B.Msisdn and A.AppId = B.AppId
where A.Count > isnull(B.count, 0) + 1

/* updating App table */
update app
set 
---subscribeurl = 'http://r.rayanelectronic.com/robottest/rd4sd752g4subscribe.php'
---unsubscribeurl = 'http://r.rayanelectronic.com/robottest/rd4sd752g4unsub.php'
chargingurl = 'http://r.rayanelectronic.com/robottest/rd4sd752g4charging.php'
---portallink = 'http://games.vdo.ae/sbdld/1234/64/gmstr.apk'
---WelcomeMessage = N'کاربر گرامی شما از طریق لینک زیر میتوانید از بازیهای بسیار مهیج و سرگرم کننده سرویس #name  استفاده کنید. #portal پس از عضویت با ارسال Off به سرشماره #shortcode  به سادگی میتوانید عضویت خود را لغو کنید. هزینه سرویس روزانه 300 تومان است'
---alreadusubscribemessage = 'عضویت شما در سرویس #name فعال می باشد'
---AlreadyunsubscribeMessage = N'این پیام رایگان است. شما عضو هیچ سرویسی نمی باشید. جهت عضویت در سرویس #name عدد 1 را به همین سرشماره ارسال کنید یا از طریق لینک زیر اقدام کنید: #portal'
---unsubscribemessage = N'عضویت شما در #name با موفقیت لغو شد. برای عضویت مجدد به  #portal مراجعه کنید. یا عدد 1 را به همین سرشماره ارسال کنید.'
where id = 1133

---Check if chargings are sent
select cast(SendToPartnerDateTime as date), appid, count(*) from charging
where cast(SendToPartnerDateTime as date) > '2017-09-01'
group by  cast(SendToPartnerDateTime as date), appid