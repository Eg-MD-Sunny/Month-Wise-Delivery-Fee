-----|| 1st Part
-----|| Name: Month Wise Delivery Fee

SELECT T.Year [Year],
       T.Month [Month],
	   Sum(t.Fee) [DeliveryFee]

FROM (

Select YEAR (s.deliveryWindowEnd) [Year],
	   Month (s.deliveryWindowEnd) [Month1],
       DateName(Month,(s.deliveryWindowEnd))[Month],
	   s.orderID [id],
	   (s.deliveryFee) [Fee]

from ThingRequest tr 
join Shipment s on s.id=tr.ShipmentId

where cast(deliverywindowend as date)>='2020-03-01'	
and cast(deliverywindowend as date)<'2020-04-01'	
and s.id not in	
		(select s.id
		from shipment s 
		where cast(dbo.tobdt(s.reconciledon) as date)>='2020-04-01' 
		and ReconciledOn is not null
		)	

and s.ShipmentStatus not in (1,9,10)
and IsReturned=0
and IsCancelled=0
and HasFailedBeforeDispatch=0
and IsMissingAfterDispatch=0

group by YEAR (s.deliveryWindowEnd),
		 Month (s.deliveryWindowEnd),
         DateName (Month,(s.deliveryWindowEnd)),
		 s.orderID,
		(s.deliveryFee)
	     
)T

group by t.Year , t.Month1 ,t.Month 
Order By t.Year , t.Month1 ,t.Month 