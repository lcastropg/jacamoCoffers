{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
{ include("$moiseJar/asl/org-obedient.asl") }


//Manager


+!announce <-
	
	makeArtifact("a_OfferControl","artifacts.A_OfferControl",[],ART_OFFERCONTROL);
	focus(ART_OFFERCONTROL);
	
	.print("It is open the coffee selling!");
	+open.

+farmerOk(FARMER_NAME)[source(AG)]: not open <-
	.print("I'm not open yet. Come back in 10 min");
	.send(AG,tell,comeBack(10)).

+farmerOk(FARMER_NAME,CP,TD,B,PW,TW,BW)[source(AG)]: open <-
	.print("The ",AG," has requested to start the coffee selling!");
	.print("Starting so...");
	setFarmer(FARMER_NAME,CP,TD,B);
	setWeights(PW,TW,BW);
	.broadcast(tell,coffeeSelling(FARMER_NAME,"open")).
	
+!offer(CP,TD,B)[source(CONSUMER_NAME)]: open <-
	.print("Received the offer from ",CONSUMER_NAME,": ($",CP," - ",TD,"h - ",B,"pts.)");
	.term2string(CONSUMER_NAME,CONSUMER_NAME_S);
	+consumer(CONSUMER_NAME_S);
	registerOffer(CONSUMER_NAME,CP,TD,B).
	
+offersComplete <-

	.print("Offers have completed! Time to sell");
	
	calculateUtilityOffers(ISWINNER,WINNER_NAME,PRICE,TIME2DELIVERY,BCA);
	if(ISWINNER){
		print("The winner is ",WINNER_NAME,"! ($",PRICE," - ",TIME2DELIVERY," hours - ",BCA," pts.");
		?farmerOk(FARMER_NAME,_,_,_,_,_,_);
		.send(FARMER_NAME,tellHow,"+!sell <- ?consumer(C); .print(\"Selling coffee to \",C).");
		.send(FARMER_NAME,tell,consumer(WINNER_NAME));
		.send(WINNER_NAME,tell,acceptedOffer(PRICE,TIME2DELIVERY,BCA));
	}else{
		.print("No winner!");
	}.
	
	+newRound <-
		.print("All offers were rejected!");
		.wait(2000);
	
		
		for(consumer(C)){			
			.send(C,achieve,makeAnotherOffer);
		
		};
		
		.print("Going to a new round...");
		.wait(1000);
		.
		
	