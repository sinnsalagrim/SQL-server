select * from ChurnList 
left join GatewayMain.dbo.CustomerSubServiceSubscription
on Gateway.dbo.ChurnList.FakeId = GatewayMain.dbo.CustomerSubServiceSubscription.CustomerId
where GatewayMain.dbo.CustomerSubServiceSubscription.IsActive =  1
order by 4 desc