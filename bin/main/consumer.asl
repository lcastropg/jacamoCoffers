{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") } 
{ include("$moiseJar/asl/org-obedient.asl") }

getInfoConsumer(CP,TD,B,PW,TW,BW) :- price(CP) & time2Delivery(TD) & bca(B) & priceWeight(PW) & timeWeight(TW) & bcaWeight(BW).

+coffeeSelling(FARMER_NAME,STATUS)[source(AG)]: STATUS = "open"  <-
	.print("I known that ",FARMER_NAME," is having coffee to sell!");
	!makeAnOffer.
	
+!makeAnOffer: getInfoConsumer(CP,TD,B,PW,TW,BW) <-

	.print("Making an offer to buy some coffee!");
	.print("My weights are (Coffe Price, Time to delivery, and SCBA) - (",PW,"|",TW,"|",BW,")");
	.print("My offer is: ($",CP," - Delivery time (hours): ",TD," - SBCA (pts): ",B,")");
	.wait(5000);
	.send(manager,achieve,offer(CP,TD,B)).
	


+acceptedOffer(PRICE,TIME2DELIVERY,BCA) <-
	.print("I got the coffee from a good price ($ ",PRICE,"). It's gonna arrive in ",TIME2DELIVERY,"hours").
	
+!makeAnotherOffer: getInfoConsumer(CP,TD,B,PW,TW,BW) & strategy(S) <-
	.print("I wasn't able to get my coffee! I will try again");
	
	CPNEW = CP * (1 + S);
	TDNEW = TD * (1 + S);
	BNEW = B * (1 - S);
	
	-price(CP);	
	-time2Delivery(TD);
	-bca(B);
	
	
	if(CPNEW < 5){
		+price(5);	
	}else{
		+price(CPNEW);
	}
	
	if(TDNEW > 48){
		+time2Delivery(48);				
	}else{
		+time2Delivery(TDNEW);
	}
	
	if(BNEW < 80.0){
		+bca(80);
	}else{
		+bca(BNEW);
	}
	
	?getInfoConsumer(C2,T2,B2,_,_,_);
	
	.print("My NEW offer is: ($",C2," - Delivery time (hours): ",T2," - SBCA (pts): ",B2,")");
	.send(manager,achieve,offer(C2,T2,B2));
	
	
	
	.