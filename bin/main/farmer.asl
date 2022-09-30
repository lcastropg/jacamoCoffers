//Farmer

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$moiseJar/asl/org-obedient.asl") }

getInfoFarmer(CP,TD,B,PW,TW,BW) :- price(CP) & time2Delivery(TD) & bca(B) & priceWeight(PW) & timeWeight(TW) & bcaWeight(BW).
!start.

+!start <-
	.wait(3000);
	commitMission("m_negotiate").

+!negotiate: getInfoFarmer(CP,TD,B,PW,TW,BW) & .my_name(AGNAME) <-
	
	.print("Announcing my coffee by the price of",CP,AGNAME,PW,TW,BW);
	.print("Telling the manager about my status!");
	.send(manager,tell,farmerOk(AGNAME,CP,TD,B,PW,TW,BW));
	.wait(consumer(CONSUMER_NAME)).

