// CArtAgO artifact code for project coffefarm

package artifacts;

import java.util.ArrayList;

import cartago.Artifact;
import cartago.OPERATION;
import cartago.ObsProperty;
import cartago.OpFeedbackParam;
import model.CoffeeValues;
import model.Farmer;
import model.Offer;

public class A_OfferControl extends Artifact {
	
	ArrayList<Offer> offerList = new ArrayList<>();
	Farmer currentFarmer;
	
	void init() {
		defineObsProperty("offers", 0);
	}

	
	@OPERATION
	void setWeights(double coffeeWeight, double timeWeight, double bcaWeight) {
		defineObsProperty("coffeeWeight", coffeeWeight);
		defineObsProperty("timeWeight", timeWeight);
		defineObsProperty("bcaWeight", bcaWeight);
	}
	
	@OPERATION
	void setFarmer(String farmerName, int price, int time2Delivery, int bca) {
		currentFarmer = new Farmer(farmerName, price, bca, time2Delivery);
	}
	
	@OPERATION
	void registerOffer(String consumerName, double price, double time2Delivery, double bca) {
		ObsProperty oP_offers = getObsProperty("offers");
		oP_offers.updateValue(oP_offers.intValue()+1);		
		offerList.add(new Offer(consumerName, price, (int)time2Delivery, (int) bca));
		if (oP_offers.intValue() >= 3) {
			signal("offersComplete");
		}
	}
	
	@OPERATION
	void calculateUtilityOffers(OpFeedbackParam<Boolean> op_isWinner, OpFeedbackParam<String> op_winnerConsumerName,OpFeedbackParam<Integer> op_price, OpFeedbackParam<Integer> op_time2Delivery, OpFeedbackParam<Integer> op_bca) {
		
		double priceWeight = getObsProperty("coffeeWeight").doubleValue();
		double timeWeight = getObsProperty("timeWeight").doubleValue();
		double bcaWeight  = getObsProperty("bcaWeight").doubleValue();
		Double major = 0.0;
		
		
		for(Offer offer : offerList) {
			offer.utility += priceWeight * ((offer.price - CoffeeValues.MIN_COFFEEPRICE.getValue()) / (CoffeeValues.MAX_COFFEEPRICE.getValue() - CoffeeValues.MIN_COFFEEPRICE.getValue()));
			offer.utility += timeWeight *  ((offer.time2Delivery - CoffeeValues.MIN_TIME.getValue()) / (CoffeeValues.MAX_TIME.getValue() - CoffeeValues.MIN_TIME.getValue()));
			offer.utility += bcaWeight *  ((offer.bca - CoffeeValues.MIN_BCA.getValue()) / (CoffeeValues.MAX_BCA.getValue() - CoffeeValues.MIN_BCA.getValue()));
			
			if(major.doubleValue() < offer.utility) {
				major = Double.valueOf(offer.utility);
				op_winnerConsumerName.set(offer.consumer);
				op_isWinner.set(true);
				op_price.set((int)offer.price);
				op_time2Delivery.set(offer.time2Delivery);
				op_bca.set(offer.bca);
			}
		}
		
		if(major < ((double) CoffeeValues.THRESHOLD.getValue() / 10)) {
			System.out.println("Major: " + major + " - " + (double)CoffeeValues.THRESHOLD.getValue() / 10);
			op_isWinner.set(false);
			offerList.clear();
			ObsProperty oP_offers = getObsProperty("offers");
			oP_offers.updateValue(0);
			signal("newRound");
		}
		else {
			System.out.println("Utility winner: " + major + " - Threshold: " + (double)CoffeeValues.THRESHOLD.getValue() / 10);

			
		}
		
		
		
		for(Offer offer : offerList) {
			System.out.println(offer);
		}
	}
}

